/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
import haxe.xml.Fast;
import sys.io.File;
import sys.FileSystem;
import pony.text.XmlTools;
import pony.text.TextTools;
import pony.time.DeltaTime;

/**
 * Share
 * @author AxGord <axgord@gmail.com>
 */
class Utils {
	
	public static inline var MAIN_FILE:String = 'pony.xml';
	public static inline var NPORT:Int = 48654;

	public static var isWindows(get, never):Bool;
	public static var PD(default, null):String;
	public static var toolsPath(default, null):String;
	public static var libPath(default, null):String;

	public static var ponyVersion(get, never):String;
	public static var ponyHaxelibVersion(get, never):String;
	private static var _ponyVersion:String;
	private static var hashesCache:Map<String, Map<String, Array<String>>> = new Map();

	private static function __init__():Void {
		PD = isWindows ? '\\' : '/';
		#if nodejs
		var o:String = Std.string(js.node.ChildProcess.execSync('haxelib path pony'));
		libPath = o.split('\n')[0];
		#else
		libPath = new sys.io.Process('haxelib', ['path', 'pony']).stdout.readLine();
		#end
		libPath = path(libPath);
		toolsPath = libPath + 'tools' + PD + 'bin' + PD;
	}

	public static function getHaxelibVersion():String {
		var s:String = new sys.io.Process('haxelib', ['list', 'pony']).stdout.readLine();
		return s.substring(s.indexOf('[') + 1, s.length - 1);
	}

	private static inline function get_isWindows():Bool return Sys.systemName() == 'Windows';

	public static function path(s:String):String return StringTools.replace(StringTools.replace(s, '/', PD), '\\', PD);

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
	
	public static function getXml():Fast {
		if (FileSystem.exists(MAIN_FILE))
			return XmlTools.fast(File.getContent(MAIN_FILE)).node.project;
		else
			return null;
	}

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

	public static function get_ponyHaxelibVersion():String {
		return getHaxelibVersion().split(':')[0];
	}

	public static function getPath(file:String):String {
		return file.substr(0, file.lastIndexOf('/')+1);
	}

	public static function createPath(file:String):Void {
		var path = getPath(file);
		if (path != '' && !FileSystem.exists(path))
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
		var content = ['private static function main():Void {'];
		if (main != null) {
			for (e in main) content.push('\t$e');
		} else {
			content.push('\t');
		}
		content.push('}\n');
		createHaxeFile(file, content);
	}

	public static inline function ansiForeground(s:String, c:AnsiForeground):String {
		return isWindows ? s : TextTools.ansiForeground(s, c);
	}

	public static inline function ansiUnderlined(s:String):String {
		return isWindows ? s : TextTools.ansiUnderlined(s);
	}

	#if neko

	public static function runNode(name:String, ?args:Array<String>):Int {
		if (args == null) args = [];
		Sys.println('Run: $name.js');
		var a = [toolsPath + name + '.js'];
		for (e in args) a.push(e);
		return Sys.command('node', a);
	}

	public static function runAndKeepNode(name:String, ?args:Array<String>):Void {
		Sys.println('Keep run: $name.js');
		while (true) runNode(name, args);
	}

	public static function asyncRunNode(name:String, ?args:Array<String>):sys.io.Process {
		Sys.println('Async run: $name.js');
		return new sys.io.Process('node', [toolsPath + name + '.js'].concat(args));
	}

	public static function getHashes(file:String):Map<String, Array<String>> {
		if (hashesCache.exists(file)) return hashesCache[file];
		var c = FileSystem.exists(file) ? File.getContent(file) : '';
		var m = new Map<String, Array<String>>();
		for (e in c.split('\n')) {
			var a = e.split(':');
			if (a.length > 1)
				m[a[0]] = a[1].split(',');
		}
		return hashesCache[file] = m;
	}

	public static function saveHashes(file:String, map:Map<String, Array<String>>):Void {
		hashesCache[file] = map;
		File.saveContent(file, [for (k in map.keys()) k + ':' + map[k].join(',')].join('\n'));
	}

	#end

}