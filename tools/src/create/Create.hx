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
package create;

import types.ProjectType;

class Create {

	private static inline var outputDir:String = 'bin/';
	private static inline var outputFile:String = 'app';

	public static function run(args:Array<String>):Void {

		var type:ProjectType = null;
		if (args.length > 0) for (t in ProjectType.createAll()) {
			if (t.getName().toLowerCase() == args[0].toLowerCase()) {
				type = t;
				break;
			}
		}

		if (type == null) {
			Utils.error('Wrong app type');
		}

		var name:String = args[1];

		if (sys.FileSystem.exists(Utils.MAIN_FILE)) Utils.error(Utils.MAIN_FILE + ' exists');
				
		var project = new Project(name);

		if (type != null) switch type {
			case ProjectType.Server: create.targets.Server.set(project);
			case ProjectType.JS: create.targets.JS.set(project);
			case ProjectType.Pixi, ProjectType.Pixixml: create.targets.Pixi.set(project);
			case ProjectType.Node: create.targets.Node.set(project);
		}

		Utils.savePonyProject(project.result());

		var main = project.getMain();

		var vscAllow:Bool = create.ides.VSCode.allowCreate;

		if (vscAllow) create.ides.VSCode.createDir();

		var needHtml:Bool = false;
		var ponycmd:String = 'build';
		if (type != null) switch type {
			case ProjectType.JS:
				Utils.createPath(main);
				var data:String = haxe.Resource.getString('jstemplate.hx');
				sys.io.File.saveContent(main, data);
				if (vscAllow) create.ides.VSCode.createChrome(project.server.httpPort);
				needHtml = true;
			case ProjectType.Pixi:
				Utils.createPath(main);
				var data:String = haxe.Resource.getString('pixitemplate.hx');
				sys.io.File.saveContent(main, data);
				if (vscAllow) create.ides.VSCode.createChrome(project.server.httpPort);
				needHtml = true;
			case ProjectType.Pixixml:
				Utils.createPath(main);
				var data:String = haxe.Resource.getString('pixixmltemplate.hx');
				sys.io.File.saveContent(main, data);
				var xdata:String = haxe.Resource.getString('pixixmltemplate.xml');
				sys.io.File.saveContent('app.xml', xdata);
				if (vscAllow) create.ides.VSCode.createChrome(project.server.httpPort);
				needHtml = true;
			case ProjectType.Node:
				//ponycmd = 'run';
				Utils.createEmptyMainFile(main);
				if (vscAllow) create.ides.VSCode.createNode(project.build.outputPath, outputFile);
			case ProjectType.Server:
				if (vscAllow) create.ides.VSCode.create(null);
				return;
			case _:
		}

		if (needHtml) {
			var html:String = haxe.Resource.getString('template.html');
			html = StringTools.replace(html, '::TITLE::', name == null ? 'App' : name);
			html = StringTools.replace(html, '::APP::', project.build.getOutputFile());
			sys.FileSystem.createDirectory(project.build.outputPath);
			sys.io.File.saveContent(project.build.outputPath + 'index.html', html);
		}
		
		if (vscAllow) create.ides.VSCode.create(ponycmd);
		create.ides.HaxeDevelop.create(name, main, project.getLibs(), project.getCps(), ponycmd);
	}

}