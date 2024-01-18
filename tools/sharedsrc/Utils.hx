import haxe.Json;
import haxe.io.Bytes;
import haxe.xml.Parser.XmlParserException;

import pony.Fast;
import pony.SPair;
import pony.text.TextTools;
import pony.text.XmlTools;

import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

/**
 * Share
 * @author AxGord <axgord@gmail.com>
 */
class Utils {

	public static inline var MAIN_FILE: String = 'pony.xml';
	public static inline var NPORT: Int = 48654;

	private static inline var SRC: String = 'src';

	public static var isWindows(get, never): Bool;
	public static var isLinux(get, never): Bool;
	public static var PD(default, null): String;
	public static var toolsPath(default, null): String;
	public static var libPath(default, null): String;

	public static var ponyVersion(get, never): String;
	public static var ponyHaxelibVersion(get, never): String;
	private static var _ponyVersion: String;
	private static var hashesCache: Map<String, Map<String, Array<String>>> = new Map();

	private static function __init__(): Void {
		PD = isWindows ? '\\' : '/';
		libPath = pony.Tools.ponyPath();
		libPath = path(libPath);
		toolsPath = libPath + 'tools' + PD + 'bin' + PD;
	}

	public static function getHaxelibVersion(): String {
		var s: String = new Process('haxelib', ['list', 'pony']).stdout.readLine();
		return s.substring(s.indexOf('[') + 1, s.length - 1);
	}

	private static inline function get_isWindows(): Bool return Sys.systemName() == 'Windows';
	private static inline function get_isLinux(): Bool return Sys.systemName() == 'Linux';

	public static function path(s: String): String return StringTools.replace(StringTools.replace(s, '/', PD), '\\', PD);

	public static function command(name: String, args: Array<String>, ?hide: Array<String>): Void {
		var s: String = name + ' ' + args.join(' ');
		if (hide != null) for (h in hide) s = StringTools.replace(s, h, TextTools.repeat('*', h.length));
		Sys.println(s);
		var r: Int = Sys.command(name, args);
		if (r > 0) error('$name error $r');
	}

	public static function parseArgs(args: Array<String>): AppCfg {
		var debug: Bool = args.indexOf('debug') != -1;
		var app: String = null;
		for (a in args) if (a != 'debug' && a != 'release') {
			app = a;
			break;
		}
		return {app: app, debug: debug};
	}

	public static function dirIsGit(path: String): Bool {
		var cwd = new Cwd(path);
		cwd.sw();
		var r: Bool = try {
			var p: Process = new Process('git', ['rev-parse', '--is-inside-work-tree']);
			var line: String = p.stdout.readLine();
			p.close();
			TextTools.isTrue(line);
		} catch (err) {
			false;
		}
		cwd.sw();
		return r;
	}

	public static function gitHash(file: String): Bytes {
		var a: SPair<String> = TextTools.lastSplit(file, '/');
		var path: String = a.b == '' ? '' : a.a;
		var file: String = a.b == '' ? a.a : a.b;
		var cwd = new Cwd(path);
		cwd.sw();
		var p: Process = new Process('git', ['hash-object', file]);
		var s: String = '';
		while (true) {
			try {
				var ch: String = p.stdout.readString(1);
				if (ch == null || ch == '\n') break;
				s += ch;
			} catch (err) {
				break;
			}
		}
		p.close();
		cwd.sw();
		return Bytes.ofHex(s);
	}

	public static function getXml(): Fast {
		if (FileSystem.exists(MAIN_FILE)) {
			try {
				return XmlTools.fast(File.getContent(MAIN_FILE)).node.project;
			} catch (e: XmlParserException) {
				xmlError(MAIN_FILE, e);
			}
		}
		return null;
	}

	public static function xmlError(file: String, e: XmlParserException): Void {
		error('${FileSystem.absolutePath(file)}:${e.lineNumber}: characters ${e.positionAtLine}-${e.positionAtLine + 1}: ${e.message}');
	}

	public static function error(message: String, errCode: Int = 1): Void {
		#if neko
		Sys.stderr().writeString(message + '\n');
		#else
		Sys.println(message);
		#end
		exit(errCode);
	}

	public static function exit(errCode: Int = 0): Void {
		#if neko
		@SuppressWarnings('checkstyle:MagicNumber')
		if (isLinux) Sys.sleep(0.3); // finish print messages
		#end
		Sys.exit(errCode);
	}

	public static function saveJson(file: String, jdata: Any): Void {
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

	public static function saveXML(file: String, xml: Xml): Void File.saveContent(file, XmlTools.document(xml));
	public static function savePonyProject(xml: Xml): Void saveXML(MAIN_FILE, xml);

	public static function get_ponyVersion(): String {
		if (_ponyVersion != null) {
			return _ponyVersion;
		} else {
			var file: String = libPath + 'haxelib.json';
			var data: Dynamic = Json.parse(File.getContent(file));
			return _ponyVersion = data.version;
		}
	}

	public static function get_ponyHaxelibVersion(): String return getHaxelibVersion().split(':')[0];
	public static function getPath(file: String): String return file.substr(0, file.lastIndexOf('/') + 1);

	public static function createPath(file: String): Void {
		var path: String = getPath(file);
		if (path != '' && !FileSystem.exists(path)) FileSystem.createDirectory(path);
	}

	public static function createHaxeFile(file: String, ?content: Array<String>): Void {
		if (FileSystem.exists(file)) return;
		createPath(file);
		var f: String = file.substr(file.lastIndexOf('/') + 1);
		var cl: String = f.substr(0, f.lastIndexOf('.'));
		var c: String = 'class $cl {\n\n';
		if (content != null) for (e in content) c += '\t$e\n';
		c += '}';
		File.saveContent(file, c);
	}

	public static function createEmptyMainFile(file: String, ?main: Array<String>): Void {
		var content: Array<String> = ['private static function main():Void {'];
		if (main != null)
			for (e in main) content.push('\t$e');
		else
			content.push('\t');
		content.push('}\n');
		createHaxeFile(file, content);
	}

	public static inline function ansiForeground(s: String, c: AnsiForeground): String
		return isWindows ? s : TextTools.ansiForeground(s, c);

	public static inline function ansiUnderlined(s: String): String return isWindows ? s : TextTools.ansiUnderlined(s);

	#if neko
	public static function runNode(name: String, ?args: Array<String>): Int {
		if (args == null) args = [];
		Sys.println('Run: $name.js');
		var jsFile: String = toolsPath + name + '.js';
		if (!FileSystem.exists(jsFile)) error(jsFile + ' - not founded');
		var a: Array<String> = [jsFile];
		for (e in args) a.push(e);
		return Sys.command('node', a);
	}

	public static function runAndKeepNode(name: String, ?args: Array<String>): Void {
		Sys.println('Keep run: $name.js');
		while (true) runNode(name, args);
	}

	public static function asyncRunNode(name: String, ?args: Array<String>): Process {
		Sys.println('Async run: $name.js');
		var jsFile: String = toolsPath + name + '.js';
		if (!FileSystem.exists(jsFile)) error(jsFile + ' - not founded');
		return new Process('node', [jsFile].concat(args));
	}

	public static function getHashes(file: String): Map<String, Array<String>> {
		if (hashesCache.exists(file)) return hashesCache[file];
		var c: String = FileSystem.exists(file) ? File.getContent(file) : '';
		var m: Map<String, Array<String>> = new Map<String, Array<String>>();
		for (e in c.split('\n')) {
			var a: Array<String> = e.split(':');
			if (a.length > 1) m[a[0]] = a[1].split(',');
		}
		return hashesCache[file] = m;
	}

	public static function saveHashes(file: String, map: Map<String, Array<String>>): Void {
		hashesCache[file] = map;
		File.saveContent(file, [ for (k in map.keys()) k + ':' + map[k].join(',') ].join('\n'));
	}

	public static function getBuildString(onlyNumbers: Bool = false, nosec: Bool = false): String {
		var date: String = Date.now().toString();
		date = StringTools.replace(date, ' ', onlyNumbers ? '' : '_');
		date = StringTools.replace(date, ':', onlyNumbers ? '' : '-');
		if (onlyNumbers) date = StringTools.replace(date, '-', '');
		@SuppressWarnings('checkstyle:MagicNumber')
		if (nosec) date = date.substr(0, -2);
		return date;
	}

	public static inline function replaceBuildDate(s: String): String {
		var str: String = StringTools.replace(s, '{buildDate}', getBuildString());
		str = StringTools.replace(str, '{buildDate:onlyNumbers}', getBuildString(true));
		str = StringTools.replace(str, '{buildDate:onlyNumbers,nosec}', getBuildString(true, true));
		return str;
	}

	public static inline function replaceBuildDateIfNotNull(s: Null<String>): Null<String> return s != null ? replaceBuildDate(s) : null;
	#end

}