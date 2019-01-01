package create;

import types.ProjectType;

/**
 * Create
 * @author AxGord <axgord@gmail.com>
 */
class Create {

	private static inline var outputFile:String = 'app';

	public static function run(a:String, b:String):Void {

		if (a == 'remote') {
			if (Utils.runNode('ponyRemote', ['create', b]) > 0) return;
			pony.ZipTool.unpackFile('init.zip');
			sys.FileSystem.deleteFile('init.zip');
			Utils.command('pony', ['prepare']);
			return;
		}

		var type:ProjectType = null;
		if (a != null) for (t in ProjectType.createAll()) {
			if (t.getName().toLowerCase() == a.toLowerCase()) {
				type = t;
				break;
			}
		}

		if (type == null) {
			Utils.error('Wrong app type');
		}

		var name:String = b;

		if (sys.FileSystem.exists(Utils.MAIN_FILE)) Utils.error(Utils.MAIN_FILE + ' exists');
				
		var project = new Project(name);

		if (type != null) switch type {
			case ProjectType.Server: create.targets.Server.set(project);
			case ProjectType.JS: create.targets.JS.set(project);
			case ProjectType.CC: create.targets.CC.set(project);
			case ProjectType.Pixi, ProjectType.Pixixml: create.targets.Pixi.set(project);
			case ProjectType.Cordova: create.targets.Cordova.set(project);
			case ProjectType.Node: create.targets.Node.set(project);
			case ProjectType.Pixielectron:
				create.targets.Electron.set(project);
				create.targets.Pixi.set(project, true);
				project.secondbuild.outputFile = 'default';
				project.secondbuild.esVersion = 6;
			case ProjectType.Electron:
				create.targets.Electron.set(project);
				create.targets.JS.set(project, true);
				project.secondbuild.outputFile = 'default';
				project.secondbuild.esVersion = 6;
			case ProjectType.Monacoelectron:
				create.targets.Electron.set(project);
				create.targets.JS.set(project, true);
				project.secondbuild.outputFile = 'default';
				project.secondbuild.esVersion = 6;
				project.haxelib.addLib('monaco-editor', '0.13.0');
			case ProjectType.Neko: create.targets.Neko.set(project);
		}

		Utils.savePonyProject(project.result());

		var main = project.getMain();

		var vscAllow:Bool = create.ides.VSCode.allowCreate;

		if (vscAllow) create.ides.VSCode.createDir();

		var needHtml:String = null;
		var ponycmd:String = 'build';
		var vscodeAuto:Bool = false;
		if (type != null) switch type {
			case ProjectType.Neko:
				ponycmd = 'run';
				Utils.createEmptyMainFile(main);

			case ProjectType.JS:
				Utils.createPath(main);
				var data:String = haxe.Resource.getString('jstemplate.hx.tpl');
				sys.io.File.saveContent(main, data);
				if (vscAllow) create.ides.VSCode.createChrome(project.server.httpPort);
				needHtml = 'index.html';
			case ProjectType.CC:
				Utils.createPath(main);
				var data:String = haxe.Resource.getString('cctemplate.hx.tpl');
				sys.io.File.saveContent(main, data);
				sys.FileSystem.createDirectory(project.build.outputPath);
				var data:String = haxe.Resource.getString('cctemplate.js.tpl');
				sys.io.File.saveContent(project.build.outputPath + 'main.js', data);
				if (vscAllow) create.ides.VSCode.createChrome(project.server.httpPort);
				vscodeAuto = true;
			case ProjectType.Pixi:
				Utils.createPath(main);
				var data:String = haxe.Resource.getString('pixitemplate.hx.tpl');
				sys.io.File.saveContent(main, data);
				if (vscAllow) create.ides.VSCode.createChrome(project.server.httpPort);
				needHtml = 'index.html';
			case ProjectType.Pixixml:
				Utils.createPath(main);
				var data:String = haxe.Resource.getString('pixixmltemplate.hx.tpl');
				sys.io.File.saveContent(main, data);
				var xdata:String = haxe.Resource.getString('pixixmltemplate.xml');
				sys.io.File.saveContent('app.xml', xdata);
				if (vscAllow) create.ides.VSCode.createChrome(project.server.httpPort);
				needHtml = 'index.html';
			case ProjectType.Cordova:
				Utils.createPath(main);
				var data:String = haxe.Resource.getString('pixixmltemplate.hx.tpl');
				sys.io.File.saveContent(main, data);
				var xdata:String = haxe.Resource.getString('pixixmltemplate.xml');
				sys.io.File.saveContent('app.xml', xdata);
				if (vscAllow) create.ides.VSCode.createCordova(project.server.httpPort);
				sys.FileSystem.createDirectory(project.build.outputPath);
				createHtml(project.build.outputPath + 'index.html', 'template.html', name == null ? 'App' : name, project.build.getOutputFile());
			case ProjectType.Node:
				//ponycmd = 'run';
				Utils.createEmptyMainFile(main);
				if (vscAllow) create.ides.VSCode.createNode(project.build.outputPath, outputFile);
			case ProjectType.Pixielectron:
				Utils.createPath(main);
				sys.FileSystem.createDirectory(project.build.outputPath);
				var mdata:String = haxe.Resource.getString('electrontemplate.hx.tpl');
				sys.io.File.saveContent(project.build.getMainhx(), mdata);
				var data:String = haxe.Resource.getString('pixixmltemplate.hx.tpl');
				sys.io.File.saveContent(project.secondbuild.getMainhx(), data);
				var xdata:String = haxe.Resource.getString('pixixmltemplate.xml');
				sys.io.File.saveContent('app.xml', xdata);
				if (vscAllow) create.ides.VSCode.createElectron(project.build.outputPath);
				createHtml(project.build.outputPath + 'default.html', 'template.html', name == null ? 'App' : name, project.secondbuild.getOutputFile());
				create.targets.Node.createAndSaveNpmPackageToOutputDir(
					project, null,
					[
						'electron' => '^2.0.3'
					]
				);

			case ProjectType.Electron:
				Utils.createPath(main);
				sys.FileSystem.createDirectory(project.build.outputPath);
				var mdata:String = haxe.Resource.getString('electrontemplate.hx.tpl');
				sys.io.File.saveContent(project.build.getMainhx(), mdata);
				var data:String = haxe.Resource.getString('jstemplate.hx.tpl');
				sys.io.File.saveContent(project.secondbuild.getMainhx(), data);
				if (vscAllow) create.ides.VSCode.createElectron(project.build.outputPath);
				createHtml(project.build.outputPath + 'default.html', 'template.html', name == null ? 'App' : name, project.secondbuild.getOutputFile());
				create.targets.Node.createAndSaveNpmPackageToOutputDir(
					project, null,
					[
						'electron' => '^2.0.3'
					]
				);

			case ProjectType.Monacoelectron:
				Utils.createPath(main);
				sys.FileSystem.createDirectory(project.build.outputPath);
				var mdata:String = haxe.Resource.getString('electrontemplate.hx.tpl');
				sys.io.File.saveContent(project.build.getMainhx(), mdata);
				var data:String = haxe.Resource.getString('monacotemplate.hx.tpl');
				sys.io.File.saveContent(project.secondbuild.getMainhx(), data);
				if (vscAllow) create.ides.VSCode.createElectron(project.build.outputPath);
				createHtml(project.build.outputPath + 'default.html', 'template.html', name == null ? 'App' : name, project.secondbuild.getOutputFile());
				create.targets.Node.createAndSaveNpmPackageToOutputDir(
					project,
					[
						'monaco-editor' => '^0.13.0',
						'monaco-editor-textmate' => '^1.0.1',
						'monaco-loader' => '^0.8.2',
						'monaco-textmate' => '^1.0.1',
						'onigasm' => '^1.3.1'
					],
					[
						'electron' => '^2.0.3'
					]
				);
				
			case ProjectType.Server:
				if (vscAllow) create.ides.VSCode.create(null);
				return;
			case _:
		}

		if (needHtml != null) {
			sys.FileSystem.createDirectory(project.build.outputPath);
			createHtml(project.build.outputPath + needHtml, 'template.html', name == null ? 'App' : name, project.build.getOutputFile());
		}
		
		if (vscAllow) create.ides.VSCode.create(ponycmd, vscodeAuto);
		create.ides.HaxeDevelop.create(name, main, project.getLibs(), project.getCps(), ponycmd);

		Utils.command('pony', ['prepare']);
	}

	private static function createHtml(file:String, template:String, title:String, app:String):Void {
		var html:String = haxe.Resource.getString(template);
		html = StringTools.replace(html, '::TITLE::', title);
		html = StringTools.replace(html, '::APP::', app);
		sys.io.File.saveContent(file, html);
	}

}