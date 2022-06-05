package module;

import pony.Fast;
import pony.SPair;
import pony.ZipTool;
import pony.fs.Dir;
import pony.fs.File;
import pony.fs.Unit;

import types.BASection;

using Lambda;
using pony.text.TextTools;
using pony.text.XmlTools;

/**
 * Hashlink module
 * @author AxGord <axgord@gmail.com>
 */
class Hashlink extends CfgModule<HashlinkConfig> {

	private static inline var PRIORITY: Int = 10;

	public function new() super('hl');

	override public function init(): Void initSections(PRIORITY, BASection.Build);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new HashlinkReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Build,
			output: null,
			hl: null,
			main: null,
			data: [],
			libs: [],
			title: null,
			id: null,
			version: null,
			versionName: null,
			storeFile: null,
			storePassword: null,
			keyAlias: null,
			keyPassword: null,
			abiFilters: null,
			splitAbi: false,
			roundIcon: true,
			platformData: null,
			orientation: null,
			gcMarkThreshold: 0.2,
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: HashlinkConfig): Void {
		var output: String = cfg.output.a;
		if (output == null) error('HL output not set');
		if (output.charAt(0) == '/') error('Wrong output path');
		if (cfg.hl == null) error('HL binary not set');
		if (cfg.hl != 'android') {
			if (cfg.main == null) error('Main file not set');
			if (!(cfg.main: File).exists) error('Main file not found');
		}
		if (cfg.output.b != null) {
			if (cfg.output.b.isTrue()) {
				log('Clear ' + output);
				(output : Dir).deleteContent();
			} else if (cfg.output.b.toLowerCase() == 'rimraf') {
				log('Clear ' + output);
				Utils.command('rimraf', [output]);
			}
		}
		var ignoreLibs: Array<String> = ['mysql.hdll', 'mysql.lib'].filter(
			function(lib: String): Bool return !cfg.libs.exists(function(f: String): Bool return lib.substr(0, f.length) == f)
		);
		ignoreLibs.push('.h');
		ignoreLibs.push('.c');
		output = output.setLast('/');
		switch cfg.hl {
			case 'mac':
				var runhl: String = Utils.libPath + 'redist/runhl.app.zip';
				ZipTool.unpackFile(runhl, output, true, ignoreLibs, function(s: String): Void log(s));
				output += 'Contents/';
				var o: String = output;
				output += 'Resources/';
				if (!Utils.isWindows) {
					Utils.command('chmod', ['+x', o + 'MacOS/runhl']);
					Utils.command('chmod', ['+x', output + 'hl']);
				}
			case 'android':
				Utils.createPath(output);
				var outputDir: Dir = output;
				var template: Dir = Utils.toolsPath + 'heaps_android/';
				template.copyTo(output);

				var outputApp: Dir = outputDir + 'app';
				var buildGradle: File = outputApp.file('build.gradle');
				var buildGradleTemplate: File = outputApp.file('build.gradle.tpl');
				var abiFilters: String = cfg.abiFilters != null ? cfg.abiFilters : 'x86,x86_64,armeabi-v7a,arm64-v8a';
				buildGradle.content = new haxe.Template(buildGradleTemplate.content).execute({
					split: cfg.splitAbi,
					abiInclude: abiFilters.split(',').map(TextTools.quote.bind(_, '"')).join(', ')
				});
				buildGradleTemplate.delete();

				var outputSrc: Dir = outputApp + 'src';
				var outputMain: Dir = outputSrc + 'main';

				log('Orientation ${cfg.orientation}');

				processTemplate(outputMain.file('AndroidManifest.xml'), {
					id: cfg.id,
					roundIcon: cfg.roundIcon,
					fixedOrientation: cfg.orientation != null,
					orientation: cfg.orientation
				});

				var patchedsdl: Dir = outputSrc + 'patchedsdl';
				processTemplate(patchedsdl.file('SDLActivity.java'), {
					autoOrientation: cfg.orientation == null
				});

				var patchedhl: Dir = outputSrc + 'patchedhl';
				processTemplate(patchedhl.file('gc.c'), {
					gcMarkThreshold: cfg.gcMarkThreshold
				});

				var gradleProps: Array<SPair<String>> = [
					['org.gradle.jvmargs', '-Xmx2048m'],
					['APPLICATION_ID', cfg.id],
					['VERSION_CODE', cfg.version],
					['VERSION_NAME', cfg.versionName],
					['RELEASE_STORE_FILE', '../../../' + cfg.storeFile],
					['RELEASE_STORE_PASSWORD', cfg.storePassword],
					['RELEASE_KEY_ALIAS', cfg.keyAlias],
					['RELEASE_KEY_PASSWORD', cfg.keyPassword]
				];
				gradleProps.push(['ABI_FILTERS', abiFilters]);
				outputDir.file('gradle.properties').content = [
					for (p in gradleProps) '${p.a}=${p.b}'
				].join('\n');

				var outputRes: Dir = outputMain + 'res';

				if (cfg.platformData != null) {
					var platformData: Dir = cfg.platformData;
					var resSrc: Dir = platformData + 'res';
					if (resSrc.exists) {
						log('Remove default icon');
						for (dir in outputRes.dirs()) {
							if (StringTools.startsWith(dir.name, 'drawable') || StringTools.startsWith(dir.name, 'mipmap')) {
								dir.deleteContent();
								dir.delete();
							}
						}
					}
					platformData.copyTo(outputMain);
				}

				((outputRes + 'values/strings.xml'): File).content = '<resources><string name="app_name">${cfg.title}</string></resources>';
			case _:
				ZipTool.unpackFile(cfg.hl, output, true, ignoreLibs, function(s: String): Void log(s));
		}
		var dataOutput: String = output + (cfg.hl == 'android' ? 'app/src/main/assets/' : '');
		for (d in cfg.data) {
			var u: Unit = d.a + d.b;
			if (u.exists)
				u.copyTo(dataOutput + d.b);
			else
				error('data ' + u + ' not found');
		}
		if (cfg.hl == 'android') {
			var cwd: Cwd = new Cwd(output);
			cwd.sw();
			var task: String = cfg.debug ? 'assembleDebug' : 'assembleRelease';
			if (Utils.isWindows)
				Utils.command('gradlew.bat', [task]);
			else
				Utils.command('sh', ['gradlew', task]);
			cwd.sw();
		} else {
			(cfg.main: File).copyToDir(output, 'hlboot.dat');
		}
	}

	private function processTemplate(file: File, context: Dynamic): Void {
		var templateFile: File = file.first + '.tpl';
		log('processTemplate $templateFile -> $file');
		file.content = new haxe.Template(templateFile.content).execute(context);
		templateFile.delete();
	}

}

private typedef HashlinkConfig = {
	> types.BAConfig,
	output: SPair<String>,
	hl: String,
	main: String,
	data: Array<SPair<String>>,
	libs: Array<String>,
	title: Null<String>,
	id: Null<String>,
	version: Null<String>,
	versionName: Null<String>,
	storeFile: Null<String>,
	storePassword: Null<String>,
	keyAlias: Null<String>,
	keyPassword: Null<String>,
	abiFilters: Null<String>,
	platformData: Null<String>,
	splitAbi: Bool,
	roundIcon: Bool,
	orientation: Null<String>,
	gcMarkThreshold: Float
}

private class HashlinkReader extends BAReader<HashlinkConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'output':
				cfg.output = new SPair(normalize(xml.innerData), xml.has.clean ? normalize(xml.att.clean) : null);
			case 'hl':
				cfg.hl = normalize(xml.innerData);
			case 'main':
				cfg.main = normalize(xml.innerData);
			case 'data':
				var data: String = '';
				try {
					data = normalize(xml.innerData);
				} catch (e: Dynamic) {}
				cfg.data.push(new SPair(normalize(xml.att.from), data));
				cfg.roundIcon = !xml.isFalse('roundIcon');
			case 'lib':
				cfg.libs.push(normalize(xml.innerData));
			case 'title':
				cfg.title = normalize(xml.innerData);
			case 'id':
				cfg.id = normalize(xml.innerData);
			case 'version':
				cfg.version = normalize(xml.innerData);
			case 'versionName':
				cfg.versionName = normalize(xml.innerData);
			case 'storeFile':
				cfg.storeFile = normalize(xml.innerData);
			case 'storePassword':
				cfg.storePassword = normalize(xml.innerData);
			case 'keyAlias':
				cfg.keyAlias = normalize(xml.innerData);
			case 'keyPassword':
				cfg.keyPassword = normalize(xml.innerData);
			case 'abiFilters':
				cfg.splitAbi = xml.isTrue('split');
				cfg.abiFilters = normalize(xml.innerData);
			case 'platformData':
				cfg.platformData = normalize(xml.innerData);
			case 'orientation':
				cfg.orientation = normalize(xml.innerData);
			case 'gcMarkThreshold':
				cfg.gcMarkThreshold = Std.parseFloat(normalize(xml.innerData));
			case _:
				super.readNode(xml);
		}
	}

	override private function clean(): Void {
		cfg.output = null;
		cfg.hl = null;
		cfg.main = null;
		cfg.data = [];
		cfg.libs = [];
		cfg.title = null;
		cfg.id = null;
		cfg.version = null;
		cfg.versionName = null;
		cfg.storeFile = null;
		cfg.storePassword = null;
		cfg.keyAlias = null;
		cfg.keyPassword = null;
		cfg.abiFilters = null;
		cfg.splitAbi = false;
		cfg.roundIcon = true;
		cfg.orientation = null;
		cfg.gcMarkThreshold = 0.2;
	}

}