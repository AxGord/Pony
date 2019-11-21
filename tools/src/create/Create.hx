package create;

import haxe.Resource;
import create.section.Config.ConfigOptions;
import create.ides.VSCode;
import create.ides.HaxeDevelop;
import sys.FileSystem;
import sys.io.File;
import types.ProjectType;

/**
 * Create
 * @author AxGord <axgord@gmail.com>
 */
class Create {

	private static var outputFile: String = 'app';

	public static function run(sType: String, name: String): Void {
		// todo: create remote key@host:port
		var type: ProjectType = null;
		if (sType != null) for (t in ProjectType.createAll()) {
			if (t.getName().toLowerCase() == sType.toLowerCase()) {
				type = t;
				break;
			}
		}
		if (type == null) Utils.error('Wrong app type');
		if (FileSystem.exists(Utils.MAIN_FILE)) Utils.error(Utils.MAIN_FILE + ' exists');
		var project: Project = new Project(name);
		setProjectConfig(project, type);
		Utils.savePonyProject(project.result());
		createProjectData(project, type);
		Utils.command('pony', ['prepare']);
	}

	private static function setProjectConfig(project: Project, type: ProjectType): Void {
		switch type {
			case ProjectType.Server: create.targets.Server.set(project);
			case ProjectType.JS: create.targets.JS.set(project);
			case ProjectType.CC: create.targets.CC.set(project);
			case ProjectType.Pixi, ProjectType.Pixixml: create.targets.Pixi.set(project);
			case ProjectType.Cordova: create.targets.Cordova.set(project);
			case ProjectType.Node: create.targets.Node.set(project);
			case ProjectType.Site:
				create.targets.Node.set(project);
				project.config.active = true;
				project.config.options['port'] = '8080';
				project.config.options['mysql'] = ([
					'host' => 'localhost',
					'port' => 'port',
					'user' => 'root',
					'password' => '',
					'database' => 'testdatabase'
				]:ConfigOptions);
				project.haxelib.addLib('continuation');
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
	}

	public static function createProjectData(project: Project, type: ProjectType): Void {
		var vscAllow: Bool = VSCode.allowCreate;
		if (vscAllow) VSCode.createDir();
		switch type {
			case ProjectType.Neko:
				project.build.createEmptyMainhx();
				if (vscAllow) VSCode.createExtensions(false);
			case ProjectType.JS:
				project.build.createMainhx('jstemplate.hx.tpl');
				if (vscAllow) VSCode.createChrome(project.server.httpPort);
				createIndexHtml(project);
			case ProjectType.CC:
				project.build.createMainhx('cctemplate.hx.tpl');
				project.build.createOutputFile('main.js', 'cctemplate.js.tpl');
				if (vscAllow) VSCode.createChrome(project.server.httpPort);
			case ProjectType.Pixi:
				project.build.createMainhx('pixitemplate.hx.tpl');
				if (vscAllow) VSCode.createChrome(project.server.httpPort);
				createIndexHtml(project);
			case ProjectType.Pixixml:
				project.build.createMainhx('pixixmltemplate.hx.tpl');
				saveTemplate('app.xml', 'pixixmltemplate.xml');
				if (vscAllow) VSCode.createChrome(project.server.httpPort);
				createIndexHtml(project);
			case ProjectType.Cordova:
				project.build.createMainhx('pixixmltemplate.hx.tpl');
				saveTemplate('app.xml', 'pixixmltemplate.xml');
				if (vscAllow) VSCode.createCordova(project.server.httpPort);
				createIndexHtml(project);
			case ProjectType.Node:
				project.build.createEmptyMainhx();
				if (vscAllow) VSCode.createNode(project.build.outputPath, outputFile);
			case ProjectType.Site:
				createSiteData(project, vscAllow);
			case ProjectType.Pixielectron:
				createPixiElectronData(project, vscAllow);
			case ProjectType.Electron:
				createElectronData(project, vscAllow);
			case ProjectType.Monacoelectron:
				createMonacoElectronData(project, vscAllow);
			case ProjectType.Server:
				if (vscAllow) VSCode.create(null);
				return;
			case _:
		}

		var ponycmd: String = type == ProjectType.Neko ? 'run' : 'build';
		if (vscAllow) VSCode.create(ponycmd, type == ProjectType.CC);
		if (project.name != null) HaxeDevelop.create(project.name, project.getMain(), project.getLibs(), project.getCps(), ponycmd);
	}

	public static function createIndexHtml(project: Project): Void {
		project.build.createOutputFile('index.html', 'template.html', [
			'TITLE' => project.rname,
			'APP' => project.build.getOutputFile()
		]);

	}

	private static function createElectronData(project: Project, vscAllow: Bool): Void {
		project.build.createMainhx('electrontemplate.hx.tpl');
		project.secondbuild.createMainhx('jstemplate.hx.tpl');
		if (vscAllow) VSCode.createElectron(project.build.outputPath);
		project.build.createOutputFile('default.html', 'template.html', [
			'TITLE' => project.rname,
			'APP' => project.secondbuild.getOutputFile()
		]);
		create.targets.Node.createAndSaveNpmPackageToOutputDir(
			project, null,
			[
				'electron' => '^2.0.3'
			]
		);
	}

	private static function createPixiElectronData(project: Project, vscAllow: Bool): Void {
		project.build.createMainhx('electrontemplate.hx.tpl');
		project.secondbuild.createMainhx('pixixmltemplate.hx.tpl');
		saveTemplate('app.xml', 'pixixmltemplate.xml');
		if (vscAllow) VSCode.createElectron(project.build.outputPath);
		project.build.createOutputFile('default.html', 'template.html', [
			'TITLE' => project.rname,
			'APP' => project.secondbuild.getOutputFile()
		]);
		create.targets.Node.createAndSaveNpmPackageToOutputDir(
			project, null,
			[
				'electron' => '^2.0.3'
			]
		);
	}

	private static function createMonacoElectronData(project: Project, vscAllow: Bool): Void {
		project.build.createMainhx('electrontemplate.hx.tpl');
		project.secondbuild.createMainhx('monacotemplate.hx.tpl');
		if (vscAllow) VSCode.createElectron(project.build.outputPath);
		project.build.createOutputFile('default.html', 'template.html', [
			'TITLE' => project.rname,
			'APP' => project.secondbuild.getOutputFile()
		]);
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
	}

	private static function createSiteData(project: Project, vscAllow: Bool): Void {
		var path: String = project.build.getMainhxPath();
		createDirs([
			path,
			path + 'models',
			'bin/home/',
			'bin/home/language/',
			'bin/home/templates/',
			'bin/home/templates/Default/',
			'bin/home/templates/Default/includes/',
			'bin/home/templates/Default/pages/',
			'bin/home/templates/Default/static/',
			project.build.outputPath
		]);
		project.build.createMainhx('site.hx.tpl');
		if (vscAllow) VSCode.createNode(project.build.outputPath, outputFile);
	}

	@:extern private static inline function createDirs(a: Array<String>): Void {
		for (d in a) FileSystem.createDirectory(d);
	}

	private static function saveTemplate(file:String, template:String, ?replaces: Map<String, String>):Void {
		var data: String = Resource.getString(template);
		if (replaces != null) for (key in replaces.keys()) data = StringTools.replace(data, '::$key::', replaces[key]);
		File.saveContent(file, data);
	}

}