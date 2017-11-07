/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
		for (xml in gxml.nodes.build) {
			if (command.length > 0) {
				command.push('--next');
			}
			pushCommands(xml);
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
			}
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