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
package create;

import create.section.*;

class Project {

	public var run(default, null):Run = new Run();
	public var server(default, null):Server = new Server();
	public var config(default, null):Config = new Config();
	public var download(default, null):Download = new Download();
	public var haxelib(default, null):Haxelib = new Haxelib();
	public var build(default, null):Build = new Build();
	public var secondbuild(default, null):Build = new Build();
	public var uglify(default, null):Uglify = new Uglify();
	public var seconduglify(default, null):Uglify = new Uglify();
	public var npm(default, null):Npm = new Npm();
	public var url(default, null):Url = new Url();

	public var name:String;
	public var rname(get, never):String;

	public function new(name:String) this.name = name;

	public function result():Xml {
		var root = Xml.createElement('project');
		if (name != null) root.set('name', name);

		if (!config.active && build.active) {
			var cfg = Xml.createElement('config');
			cfg.addChild(Xml.createComment('Put configuration here'));
			root.addChild(cfg);
		}

		if (run.active) root.addChild(run.result());
		if (server.active) root.addChild(server.result());
		if (config.active) root.addChild(config.result());
		if (download.active) root.addChild(download.result());
		if (haxelib.active) root.addChild(haxelib.result());
		if (npm.active) root.addChild(npm.result());
		if (build.active) {
			root.addChild(build.result());
			if (uglify.active) {
				uglify.outputPath = build.outputPath;
				uglify.outputFile = build.getOutputFile();
				root.addChild(uglify.result());
			}
		}
		if (secondbuild.active) {
			root.addChild(secondbuild.result());
			if (seconduglify.active) {
				seconduglify.outputPath = secondbuild.outputPath;
				seconduglify.outputFile = secondbuild.getOutputFile();
				root.addChild(seconduglify.result());
			}
		}
		if (url.active) root.addChild(url.result());
		
		if (root.firstChild() == null) {
			root.addChild(Xml.createComment('Put configuration here'));
		}
		return root;
	}

	public function getMain():String {
		return build.active ? build.getMainhx() : null; 
	}

	public function getCps():Array<String> {
		return [];
	}

	public function getLibs():Map<String, String> {
		var map = new Map<String, String>();
		if (haxelib.active) {
			for (lib in haxelib.libs.keys()) map[lib] = haxelib.libs[lib];
		}
		if (build.active) {
			for (lib in build.libs.keys()) map[lib] = build.libs[lib];
		}
		return map;
	}

	public function setRun(cmd:String):Void {
		run.active = true;
		run.path = build.outputPath;
		run.command = cmd + ' ' + build.outputFile;
	}

	private function get_rname():String return name == null ? 'App' : name;

}