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
package module;

import haxe.xml.Fast;
import sys.FileSystem;
import sys.io.File;
import types.BASection;

/**
 * Build module
 * @author AxGord <axgord@gmail.com>
 */
class Build extends CfgModule<BuildConfig> {

	private static inline var PRIORITY:Int = 1;

	private var haxelib:Array<String> = [];
	private var server:Bool = false;

	public function new() super('build');

	override public function init():Void {
		if (xml == null) return;
		if (modules.xml.hasNode.haxelib) {
			for (e in modules.xml.node.haxelib.nodes.lib) {
				var a = e.innerData.split(' ');
				haxelib.push('-lib');
				haxelib.push(a.join(':'));
			}
		}
		server = modules.xml.hasNode.server && modules.xml.node.server.hasNode.haxe;
		initSections(PRIORITY, BASection.Build);
	}

	override private function readConfig(ac:AppCfg):Void {
		for (xml in nodes)
			new BuildConfigReader(xml, {
				debug: ac.debug,
				app: ac.app,
				before: false,
				section: BASection.Build,
				command: [],
				haxeCompiler: 'haxe',
				hxml: null,
				runHxml: []
			}, configHandler);
	}

	override private function run(cfg:BuildConfig):Void {
		if (cfg.command.length > 0) {
			var cmd = cfg.command.concat(haxelib);
			if (cfg.app != null) {
				cmd.push('-D');
				cmd.push('app=${cfg.app}');
			}
			if (cfg.debug) {
				cmd.push('-debug');
			}
			if (cfg.hxml != null) {
				saveHxml(cfg.hxml, cmd);
			} else {
				runCompilation(cmd, cfg.debug, cfg.haxeCompiler);
			}
		}
		for (e in cfg.runHxml) {
			runCompilation([e + '.hxml'], cfg.debug, cfg.haxeCompiler);
		}
	}

	private function saveHxml(name:String, commands:Array<String>):Void {
		name += '.hxml';
		var f = false;
		var s = '';
		for (e in commands) {
			s += e;
			s += f ? '\n' : ' ';
			f = !f;
		}
		var prev:String = sys.FileSystem.exists(name) ? File.getContent(name) : null;
		if (prev != s) {
			if (sys.FileSystem.exists('libcache.js')) sys.FileSystem.deleteFile('libcache.js');
			File.saveContent(name, s);
		}
	}

	private function runCompilation(command:Array<String>, debug:Bool, compiler:String):Void {
		if (debug && server && compiler == 'haxe') {
			var newline = "\n";
			var s = new sys.net.Socket();
			s.connect(new sys.net.Host('127.0.0.1'), Std.parseInt(modules.xml.node.server.node.haxe.innerData));
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
			Utils.command(compiler, command);
		}
	}

}

private typedef BuildConfig = { > types.BAConfig,
	command: Array<String>,
	haxeCompiler: String,
	hxml: String,
	runHxml: Array<String>
}

private class BuildConfigReader extends BAReader<BuildConfig> {

	private static inline var UT:String = 'Unknown tag';

	override private function readNode(xml:Fast):Void {
		try {
			super.readNode(xml);
		} catch (s:String) {
			if (s.substr(0, UT.length) == UT) {
				switch xml.name {
					case 'hxml':
						cfg.runHxml.push(StringTools.trim(xml.innerData));
					case 'd':
						cfg.command.push('-D');
						if (xml.has.name)
							cfg.command.push(xml.att.name + '=' + xml.innerData);
						else
							cfg.command.push(xml.innerData);
					case a:
						cfg.command.push('-' + a);
						try {
							cfg.command.push(xml.innerData);
						} catch (_:Dynamic) {}
				}
			} else {
				throw s;
			}
		}
	}

	override private function clean():Void {
		cfg.command = [];
		cfg.haxeCompiler = 'haxe';
		cfg.hxml = null;
		cfg.runHxml = [];
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'haxe': cfg.haxeCompiler = val;
			case 'hxml': cfg.hxml = val;
			case _:
		}
	}

}