import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;
import pony.text.XmlTools;

/**
 * Share
 * @author AxGord <axgord@gmail.com>
 */
class Utils {
	
	public static inline var MAIN_FILE:String = 'pony.xml';

	public static var PD(default, null):String;
	public static var toolsPath(default, null):String;
	public static var libPath(default, null):String;

	public static var ponyVersion(get, never):String;
	private static var _ponyVersion:String;

	private static function __init__():Void {
		PD = Sys.systemName() == 'Windows' ? '\\' : '/';
		var a = Sys.executablePath().split(PD);
		a.pop();
		toolsPath = a.join(PD) + PD;
		a.pop();
		a.pop();
		libPath = a.join(PD) + PD;
	}

	public static function command(name:String, args:Array<String>):Void {
		Sys.println(name + ' ' + args.join(' '));
		var r = Sys.command(name, args);
		if (r > 0) error('$name error $r');
	}

	public static function parseArgs(args:Array<String>):AppCfg {
		var debug = args.indexOf('debug') != -1;
		var app:String = null;
		for (a in args) if (a != 'debug' && a != 'release') {
			app = a;
			break;
		}
		return {app: app, debug:debug};
	}
	
	public static function getXml():Fast return XmlTools.fast(File.getContent(MAIN_FILE)).node.project;
	
	public static function error(message:String, errCode:Int = 1):Void {
		Sys.println(message);
		Sys.exit(errCode);
	}

	public static function saveJson(file:String, jdata:Dynamic):Void {
		var tdata = haxe.Json.stringify(jdata, '\n');
		while (true) {
			var ndata = StringTools.replace(tdata, '\n\n', '\n');
			if (ndata == tdata) {
				tdata = ndata;
				break;
			} else {
				tdata = ndata;
			}
		}
		File.saveContent(file, tdata);
		Sys.println('$file saved');
	}

	public static function saveXML(file:String, xml:Xml):Void {
		File.saveContent(file, XmlTools.document(xml));
	}

	public static function savePonyProject(xml:Xml):Void saveXML(MAIN_FILE, xml);
	
	public static function get_ponyVersion():String {
		if (_ponyVersion != null) {
			return _ponyVersion;
		} else {
			var file = libPath + 'haxelib.json';
			var data = haxe.Json.parse(File.getContent(file));
			return _ponyVersion = data.version;
		}
	}

	public static function getPath(file:String):String {
		return file.substr(0, file.lastIndexOf('/')+1);
	}

	public static function createPath(file:String):Void {
		var path = getPath(file);
		if (!FileSystem.exists(path))
			FileSystem.createDirectory(path);
	}

	public static function createHaxeFile(file:String, ?content:Array<String>):Void {
		if (FileSystem.exists(file)) return;
		createPath(file);
		var f = file.substr(file.lastIndexOf('/') + 1);
		var cl = f.substr(0, f.lastIndexOf('.'));
		var c = 'class $cl {\n\n';
		if (content != null) {
			for (e in content) c += '\t$e\n';
		}
		c += '}';
		File.saveContent(file, c);
	}

	public static function createEmptyMainFile(file:String, ?main:Array<String>):Void {
		var content = ['static function main() {'];
		if (main != null) {
			for (e in main) content.push('\t$e');
		} else {
			content.push('\t');
		}
		content.push('}\n');
		createHaxeFile(file, content);
	}

}