import haxe.xml.Fast;
import sys.io.File;
using pony.text.TextTools;
/**
 * Build
 * @author AxGord <axgord@gmail.com>
 */
class Build {

	public var command:Array<String> = [];
	private var debug:Bool;
	private var app:String;
	private var isHxml:Bool = false;
	private var gxml:Fast;

	public function new(xml:Fast, app:String, debug:Bool) {
		this.app = app;
		this.debug = debug;
		gxml = xml;
		
		if (app == null && xml.hasNode.apps) throw 'Please type app name';
		
		isHxml = xml.node.build.has.hxml && xml.node.build.att.hxml.isTrue();
	}

	private function writeConfig():Void {
		var f = false;
		var s = '';
		for (e in new Build(gxml, app, debug).getCommands()) {
			s += e;
			s += f ? '\n' : ' ';
			f = !f;
		}
		var prev = sys.FileSystem.exists('pony.hxml') ? File.getContent('pony.hxml') : null;
		if (prev != s) {
			if (sys.FileSystem.exists('libcache.js')) sys.FileSystem.deleteFile('libcache.js');
			File.saveContent('pony.hxml', s);
		}
	}

	public function writeConfigIfNeed():Void {
		if (gxml.node.build.has.hxml && gxml.node.build.att.hxml.isTrue()) {
			writeConfig();
		}
	}

	private function genCommands():Void {
		pushCommands(gxml.node.build);
		for (e in gxml.node.haxelib.nodes.lib) {
			var a = e.innerData.split(' ');
			command.push('-lib');
			command.push(a.join(':'));
		}
		if (app != null) {
			command.push('-D');
			command.push('app=$app');
		}
		if (debug) {
			command.push('-debug');
			// if (gxml.hasNode.server && gxml.node.server.hasNode.haxe) {
			// 	command.push('--connect');
			// 	command.push(gxml.node.server.node.haxe.innerData);
			// }
		}
	}

	public function getCommands():Array<String> {
		genCommands();
		return command;
	}

	public function run():Void {
		if (!isHxml) {
			genCommands();
			runCompilation(command);
		} else {
			writeConfig();
			runCompilation(['pony.hxml']);
		}
	}

	private function runCompilation(command:Array<String>):Void {
		if (debug && gxml.hasNode.server && gxml.node.server.hasNode.haxe) {
			var newline = "\n";
			var s = new sys.net.Socket();
			s.connect(new sys.net.Host('127.0.0.1'), Std.parseInt(gxml.node.server.node.haxe.innerData));
			var d = Sys.getCwd();
			s.write('--cwd ' + d + newline);
			s.write(command.join(newline));
			s.write("\000");

			var hasError = false;
			for (line in s.read().split(newline))
			{
				switch (line.charCodeAt(0)) {
					case 0x01: 
						neko.Lib.print(line.substr(1).split("\x01").join(newline));
					case 0x02: 
						hasError = true;
					default: 
						Sys.stderr().writeString(line + newline);
				}
			}
			if (hasError) Sys.exit(1);	
		} else {
			Sys.println('haxe ' + command.join(' '));
			var code = Sys.command('haxe', command);
			if (code > 0) Sys.exit(code);
		}
	}

	private function pushCommands(xml:Fast):Void {
		for (e in xml.elements) {
			switch e.name {
				case 'apps':
					pushCommands(e.node.resolve(app));
				case 'd':
					command.push('-D');
					if (e.has.name)
						command.push(e.att.name + '=' + e.innerData);
					else
						command.push(e.innerData);
				case 'debug': if (debug) pushCommands(e);
				case 'release': if (!debug) pushCommands(e);
				case a:
					command.push('-' + a);
					try {
						command.push(e.innerData);
					} catch (_:Dynamic) {}
			}
		}
		
	}
	
}