package create;

import pony.Tools;
import haxe.Resource;
import create.section.Config.ConfigOptions;
import create.ides.VSCode;
import create.ides.HaxeDevelop;
import sys.FileSystem;
import sys.io.File;
import types.ProjectType;
import types.HaxeTargets;

/**
 * Create
 * @author AxGord <axgord@gmail.com>
 */
class Create {

	private static var outputFile: String = 'app';
	private static var formatFile: String = 'hxformat.json';
	private static var testSertFile: String = 'testcert.p12';
	private static var electronVersion: Map<String, String> = ['electron' => '^19.0.6', 'electron-builder' => '^23.1.0'];

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
		copyFromPony(formatFile);
		Utils.command('pony', ['prepare']);
	}

	private static function copyFromPony(file: String, ?to: String): Void {
		File.copy(Tools.ponyPath() + file, Sys.getCwd() + (to != null ? to + file : file));
	}

	private static function copyFromTools(file: String, ?to: String): Void {
		File.copy(Utils.toolsPath + file, Sys.getCwd() + (to != null ? to + file : file));
	}

	private static function setElectronSecondBuild(project: Project): Void {
		project.secondbuild.hxml = 'default';
		project.secondbuild.outputFile = 'default';
		project.secondbuild.esVersion = 6;
		project.electron.active = true;
	}

	private static function setProjectConfig(project: Project, type: ProjectType): Void {
		switch type {
			case ProjectType.Server: create.targets.Server.set(project);
			case ProjectType.Sniff: create.targets.Server.sniff(project);
			case ProjectType.JS: create.targets.JS.set(project);
			case ProjectType.Swf: create.targets.Swf.swf(project);
			case ProjectType.Swc: create.targets.Swf.swc(project);
			case ProjectType.Air: create.targets.Swf.adt(project, testSertFile);
			case ProjectType.CC: create.targets.CC.set(project);
			case ProjectType.Pixi, ProjectType.Pixixml: create.targets.Pixi.set(project);
			case ProjectType.Pixielectron:
				create.targets.Electron.set(project);
				create.targets.Pixi.set(project, true);
				setElectronSecondBuild(project);
			case ProjectType.Heaps, ProjectType.Heapsxml: create.targets.Heaps.set(project);
			case ProjectType.Heapselectron:
				create.targets.Electron.set(project);
				create.targets.Heaps.setJs(project, true);
				setElectronSecondBuild(project);
			case ProjectType.Cordova: create.targets.Cordova.set(project);
			case ProjectType.Node: create.targets.Node.set(project);
			case ProjectType.Site:
				FileSystem.createDirectory('src/models');
				create.targets.Node.set(project);
				project.config.active = true;
				project.config.options['port'] = '8080';
				project.config.options['mysql'] = ([
					'host' => 'localhost',
					'port' => '3306',
					'user' => 'root',
					'password' => '',
					'database' => 'testdatabase'
				]: ConfigOptions);
				project.config.options['vk'] = new ConfigOptions();
				project.haxelib.addLib({name: 'continuation'});
			case ProjectType.Electron:
				create.targets.Electron.set(project);
				create.targets.JS.set(project, true);
				setElectronSecondBuild(project);
			case ProjectType.Monacoelectron:
				create.targets.Electron.set(project);
				create.targets.JS.set(project, true);
				setElectronSecondBuild(project);
				project.haxelib.addLib({name: 'monaco-editor', version: '0.13.0'});
			case ProjectType.Neko: create.targets.Neko.set(project);
		}
	}

	public static function createProjectData(project: Project, type: ProjectType): Void {
		var vscAllow: Bool = VSCode.allowCreate;
		if (vscAllow) VSCode.createDir();
		switch type {
			case ProjectType.Neko:
				project.build.createEmptyMainhx();
				if (vscAllow) VSCode.createExtensions();
			case ProjectType.Swf:
				project.build.createEmptyMainhx();
				if (vscAllow) VSCode.createFlash(project.build.outputPath, outputFile);
			case ProjectType.Swc: if (vscAllow) VSCode.createExtensions(false, true);
			case ProjectType.Air: createAirData(project, vscAllow);
			case ProjectType.JS: createJsData(project, vscAllow);
			case ProjectType.CC: createCCData(project, vscAllow);
			case ProjectType.Pixi: createPixiData(project, vscAllow);
			case ProjectType.Pixixml: createPixiXmlData(project, vscAllow);
			case ProjectType.Pixielectron: createPixiElectronData(project, vscAllow);
			case ProjectType.Heaps: createHeapsData(project, vscAllow);
			case ProjectType.Heapsxml: createHeapsXmlData(project, vscAllow);
			case ProjectType.Heapselectron: createHeapsElectronData(project, vscAllow);
			case ProjectType.Cordova: createCordovaData(project, vscAllow);
			case ProjectType.Node:
				project.build.createEmptyMainhx();
				if (vscAllow) VSCode.createNode(project.build.outputPath, outputFile);
			case ProjectType.Site:
				createSiteData(project, vscAllow);
			case ProjectType.Electron:
				createElectronData(project, vscAllow);
			case ProjectType.Monacoelectron:
				createMonacoElectronData(project, vscAllow);
			case ProjectType.Server, ProjectType.Sniff:
				if (vscAllow) VSCode.create(null);
				return;
			case _:
		}
		var ponycmd: String = type == ProjectType.Neko ? 'run' : 'build';
		if (vscAllow) VSCode.create(ponycmd, type == ProjectType.CC, project.server.active);
		if (project.name != null) HaxeDevelop.create(project.name, project.getMain(), project.getLibs(), project.getCps(), ponycmd);
		Gitignore.create(project, type);
	}

	private static function createAirData(project: Project, vscAllow: Bool): Void {
		project.build.createEmptyMainhx();
		Template.gen('air/', [
			create.targets.Swf.APP_XML => '::OUTPUT::' + create.targets.Swf.APP_XML
		], [
			'OUTPUT' => project.build.outputPath,
			'APP' => project.build.outputFile,
			'EXT' => project.build.outputExt(),
			'SERT' => testSertFile
		]);
		copyFromTools(testSertFile, project.build.outputPath);
		if (vscAllow) VSCode.createAir(project.build.outputPath, outputFile);
	}

	private static function createJsData(project: Project, vscAllow: Bool): Void {
		project.build.createMainhx('jstemplate.hx.tpl');
		if (vscAllow) VSCode.createChrome(project.server.httpPort);
		createIndexHtml(project);
	}

	private static function createCCData(project: Project, vscAllow: Bool): Void {
		project.build.createMainhx('cctemplate.hx.tpl');
		project.build.createOutputFile('main.js', 'cctemplate.js.tpl');
		if (vscAllow) VSCode.createChrome(project.server.httpPort);
	}

	private static function createPixiProjectsData(project: Project, vscAllow: Bool, mainTemplate: String): Void {
		project.build.createMainhx(mainTemplate);
		if (vscAllow) VSCode.createChrome(project.server.httpPort);
		createIndexHtml(project);
	}

	private static function createPixiData(project: Project, vscAllow: Bool): Void {
		createPixiProjectsData(project, vscAllow, 'pixitemplate.hx.tpl');
	}

	private static function createPixiXmlData(project: Project, vscAllow: Bool): Void {
		createPixiProjectsData(project, vscAllow, 'pixixmltemplate.hx.tpl');
		saveTemplate('app.xml', 'pixixmltemplate.xml');
	}

	private static function createPixiElectronData(project: Project, vscAllow: Bool): Void {
		project.build.createMainhx('electrontemplate.hx.tpl');
		project.secondbuild.createMainhx('pixixmltemplate.hx.tpl');
		saveTemplate('app.xml', 'pixixmltemplate.xml');
		if (vscAllow) VSCode.createElectron(project.build.outputPath);
		genSecondBuildHtml(project);
		create.targets.Node.createAndSaveNpmPackageToOutputDir(project, null, electronVersion);
	}

	private static function createHeapsProjectsData(project: Project, vscAllow: Bool, mainTemplate: String): Void {
		project.build.createMainhx(mainTemplate);
		if (vscAllow) VSCode.createHeaps(project.server.httpPort, project.build.outputPath, outputFile);
		createIndexHtml(project);
		if (project.hashlink.android != null) copyFromTools(testSertFile, project.build.outputPath);
	}

	private static function createHeapsData(project: Project, vscAllow: Bool): Void {
		createHeapsProjectsData(project, vscAllow, 'heapstemplate.hx.tpl');
	}

	private static function createHeapsXmlData(project: Project, vscAllow: Bool): Void {
		if (!FileSystem.exists('ui')) FileSystem.createDirectory('ui');
		saveTemplate('ui/main.xml', 'heapsxmltemplate.xml');
		createHeapsProjectsData(project, vscAllow, 'heapsxmltemplate.hx.tpl');
	}

	private static function createHeapsElectronData(project: Project, vscAllow: Bool): Void {
		if (!FileSystem.exists('ui')) FileSystem.createDirectory('ui');
		saveTemplate('ui/main.xml', 'heapsxmltemplate.xml');
		project.build.createMainhx('electrontemplate.hx.tpl');
		project.secondbuild.createMainhx('heapsxmlelectrontemplate.hx.tpl');
		if (vscAllow) VSCode.createElectron(project.build.outputPath);
		genSecondBuildHtml(project);
		create.targets.Node.createAndSaveNpmPackageToOutputDir(project, null, electronVersion);
	}

	private static function createCordovaData(project: Project, vscAllow: Bool): Void {
		project.build.createMainhx('pixixmltemplate.hx.tpl');
		saveTemplate('app.xml', 'pixixmltemplate.xml');
		if (vscAllow) VSCode.createCordova(project.server.httpPort);
		createIndexHtml(project);
	}

	private static function createElectronData(project: Project, vscAllow: Bool): Void {
		project.build.createMainhx('electrontemplate.hx.tpl');
		project.secondbuild.createMainhx('jstemplate.hx.tpl');
		if (vscAllow) VSCode.createElectron(project.build.outputPath);
		genSecondBuildHtml(project);
		create.targets.Node.createAndSaveNpmPackageToOutputDir(project, null, electronVersion);
	}

	private static function createMonacoElectronData(project: Project, vscAllow: Bool): Void {
		project.build.createMainhx('electrontemplate.hx.tpl');
		project.secondbuild.createMainhx('monacotemplate.hx.tpl');
		if (vscAllow) VSCode.createElectron(project.build.outputPath);
		genSecondBuildHtml(project);
		create.targets.Node.createAndSaveNpmPackageToOutputDir(
			project,
			[
				'monaco-editor' => '^0.13.0',
				'monaco-editor-textmate' => '^1.0.1',
				'monaco-loader' => '^0.8.2',
				'monaco-textmate' => '^1.0.1',
				'onigasm' => '^1.3.1'
			],
			electronVersion
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

	public static function createIndexHtml(project: Project): Void {
		project.build.createOutputFile('index.html', 'template.html', [
			'TITLE' => project.rname,
			'APP' => project.build.getOutputFile()
		]);
	}

	private static function genSecondBuildHtml(project: Project): Void {
		project.build.createOutputFile('default.html', 'template.html', [
			'TITLE' => project.rname,
			'APP' => project.secondbuild.getOutputFile()
		]);
	}

	@:extern private static inline function createDirs(a: Array<String>): Void for (d in a) FileSystem.createDirectory(d);

	private static function saveTemplate(file:String, template:String, ?replaces: Map<String, String>):Void {
		var data: String = Resource.getString(template);
		if (replaces != null) for (key in replaces.keys()) data = StringTools.replace(data, '::$key::', replaces[key]);
		File.saveContent(file, data);
	}

}