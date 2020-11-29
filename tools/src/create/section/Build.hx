package create.section;

import sys.FileSystem;
import sys.io.File;
import haxe.Resource;
import pony.text.XmlTools;
import types.*;

/**
 * Build
 * @author AxGord <axgord@gmail.com>
 */
class Build extends Section {

	public var libs: Map<String, String> = new Map();
	public var flags: Array<String> = [];
	public var args: Map<String, String> = new Map();
	public var target: HaxeTargets = null;
	public var outputFile: String = 'app';
	public var outputPath: String = 'bin/';
	public var hxml: Bool = true;
	public var cps: Array<String> = ['src'];
	public var main: String = 'Main';
	public var dce: String = 'full';
	public var analyzerOptimize: Bool = true;
	public var esVersion: Int = null;

	public function new() super('build');

	public function addLib(name: String, ?version: String): Void {
		libs[name] = version;
	}

	public function getDep(): Array<String> {
		return hxml ? [outputFile + '.hxml'] : [];
	}

	public function result(): Xml {
		init();

		if (hxml) {
			var prepare: Xml = Xml.createElement('prepare');
			prepare.set('hxml', outputFile);
			prepare.addChild(XmlTools.node('main', main));
			prepare.addChild(XmlTools.node(target, output()));
			for (cp in cps) prepare.addChild(XmlTools.node('cp', cp));
			for (name in libs.keys()) {
				var v = libs[name];
				if (v == null)
					prepare.addChild(XmlTools.node('lib', name));
				else
					prepare.addChild(XmlTools.node('lib', '$name $v'));
			}
			if (dce != null) prepare.addChild(XmlTools.node('dce', dce));
			if (analyzerOptimize) prepare.addChild(XmlTools.node('d', 'analyzer-optimize'));
			if (esVersion != null) prepare.addChild(XmlTools.node('d', 'js-es$esVersion'));
			for (name in flags) prepare.addChild(XmlTools.node('d', name));
			for (key in args.keys()) prepare.addChild(XmlTools.node(key, args[key]));

			xml.addChild(prepare);

			var build: Xml = Xml.createElement('build');
			build.addChild(XmlTools.node('hxml', outputFile));
			xml.addChild(build);
		} else {
			add('main', main);
			add(target, output());
			for (cp in cps) add('cp', cp);
			for (name in libs.keys()) {
				var v = libs[name];
				if (v == null)
					add('lib', name);
				else
					add('lib', '$name $v');
			}
			if (dce != null) add('dce', dce);
			if (analyzerOptimize) add('d', 'analyzer-optimize');
			if (esVersion != null) add('d', 'js-es$esVersion');
			for (name in flags) add('d', name);
			for (key in args.keys()) add(key, args[key]);
		}

		return xml;
	}

	public function output(): String return outputPath + getOutputFile();
	public function getOutputFile(): String return outputFile + outputExt();

	public function outputExt(): String {
		return switch target {
			case HaxeTargets.JS: '.js';
			case HaxeTargets.Neko: '.n';
			case HaxeTargets.Swf: '.swf';
		}
	}

	public function createOutputFile(file: String, template: String, ?replaces: Map<String, String>): Void {
		createOutputPathIfNeed();
		createFile(outputPath + file, template, replaces);
	}

	public function getMainhxPath(): String {
		return cps[0];
	}

	public function getMainhx(): String return gethx(main);
	public function gethx(name: String): String return getMainhxPath() + '/' + name + '.hx';

	public function createMainhx(template: String, ?replaces: Map<String, String>): Void {
		createPathToMainhxIfNeed();
		createFile(getMainhx(), template, replaces);
	}

	public function createEmptyMainhx(): Void {
		Utils.createEmptyMainFile(getMainhx());
	}

	private function createFile(file:String, template: String, ?replaces: Map<String, String>): Void {
		var data: String = Resource.getString(template);
		if (replaces != null) for (key in replaces.keys()) data = StringTools.replace(data, '::$key::', replaces[key]);
		File.saveContent(file, data);
	}

	public function createOutputPathIfNeed(): Void {
		if (!outputPathExists())
			FileSystem.createDirectory(outputPath);
	}

	public function outputPathExists(): Bool {
		return FileSystem.exists(outputPath);
	}

	public function createOutputPath(): Void {
		FileSystem.createDirectory(outputPath);
	}

	public function createPathToMainhxIfNeed(): Void {
		if (!pathToMainhxExists())
			createPathToMainhx();
	}

	public function createPathToMainhx(): Void {
		FileSystem.createDirectory(getMainhxPath());
	}

	public function pathToMainhxExists(): Bool {
		return FileSystem.exists(getMainhxPath());
	}

}