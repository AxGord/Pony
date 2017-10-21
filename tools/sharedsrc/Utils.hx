package;
import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;

/**
 * Share
 * @author AxGord <axgord@gmail.com>
 */
class Utils {
	
	public static inline var MAIN_FILE:String = 'pony.xml';
	
	public static inline var XML_REMSP_LEFT:String = '{REMSP_LEFT}';
	public static inline var XML_REMSP_RIGHT:String = '{REMSP_RIGHT}';

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
	
	public static function getXml():Fast return new Fast(Xml.parse(File.getContent(MAIN_FILE))).node.project;
	
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
		var doc = Xml.createDocument();
		doc.addChild(Xml.createProcessingInstruction('xml version="1.0" encoding="utf-8"'));
		doc.addChild(xml);
		var r = haxe.xml.Printer.print(doc, true);
		
		var a = r.split(XML_REMSP_LEFT);
		r = '';
		for (e in a) r += e.substring(0, e.lastIndexOf('>') + 1);
		a = r.split(XML_REMSP_RIGHT);
		r = '';
		for (e in a) r += e.substring(e.indexOf('<'));

		File.saveContent(file, r);
	}

	public static function savePonyProject(xml:Xml):Void saveXML(MAIN_FILE, xml);

	public static function xmlData(data:String):Xml {
		return Xml.createPCData(XML_REMSP_LEFT + data + XML_REMSP_RIGHT);
	}

	public static function xmlSimple(v:String, data:String):Xml {
		var e = Xml.createElement(v);
		e.addChild(Utils.xmlData(data));
		return e;
	}

	public static function xmlSimpleAtt(v:String, att:String, data:String):Xml {
		var e = Xml.createElement(v);
		e.set(att, data);
		return e;
	}

	public static function mapToNode(name:String, tag:String, map:Map<String, String>):Xml {
		var r = Xml.createElement(name);
		for (key in map.keys())
			r.addChild(Utils.xmlSimpleAtt(tag, key, map[key]));
		return r;
	}
	
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