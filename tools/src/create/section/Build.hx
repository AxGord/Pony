package create.section;

import haxe.Resource;
import pony.text.XmlTools;
import sys.FileSystem;
import sys.io.File;
import types.HaxeTargets;

using StringTools;

/**
 * Build
 * @author AxGord <axgord@gmail.com>
 */
class Build extends Section {

	private static final HXML: String = '.hxml';

	public var libs: Map<String, String> = [];
	public var flags: Array<String> = [];
	public var macros: Array<String> = [];
	public var args: Map<String, String> = [];
	public var target: HaxeTargets = null;
	public var outputFile: String = 'app';
	public var outputPath: String = 'bin/';
	public var hxml: String = 'app';
	public var cps: Array<String> = ['src'];
	public var main: String = 'Main';
	public var dce: String = 'full';
	public var analyzerOptimize: Bool = true;
	public var esVersion: Int = null;

	public function new() super('build');

	public function addLib(name: String, ?version: String): Void libs[name] = version;

	public function getHxmlFile(): String return hxml + HXML;

	public function getDep(): Array<String> return hxml != null ? [getHxmlFile()] : [];

	#if (haxe_ver < 4.2) override #end
	public function result(): Xml {
		init();

		if (hxml != null) {
			final prepare: Xml = Xml.createElement('prepare');
			prepare.set('hxml', hxml);
			if (main != null) prepare.addChild(XmlTools.node('main', main));
			prepare.addChild(XmlTools.node(targetKey(), output()));
			for (cp in cps) prepare.addChild(XmlTools.node('cp', cp));
			for (name => v in libs) {
				prepare.addChild(XmlTools.node('lib', v == null ? name : '$name:$v'));
			}
			if (dce != null) prepare.addChild(XmlTools.node('dce', dce));
			if (analyzerOptimize) prepare.addChild(XmlTools.node('d', 'analyzer-optimize'));
			if (esVersion != null) prepare.addChild(XmlTools.node('d', 'js-es$esVersion'));
			for (name in flags) {
				final a: Array<String> = name.split(':').map(StringTools.trim);
				final d: Xml = XmlTools.node('d', a.pop());
				prepare.addChild(d);
				if (a.length > 0) d.set('name', a.pop());
			}
			for (m in macros) prepare.addChild(XmlTools.node('m', m));
			for (key => value in args) prepare.addChild(XmlTools.node(key, value));

			xml.addChild(prepare);

			final build: Xml = Xml.createElement('build');
			build.addChild(XmlTools.node('hxml', hxml));
			xml.addChild(build);
		} else {
			add('main', main);
			add(targetKey(), output());
			for (cp in cps) add('cp', cp);
			for (name => v in libs) {
				add('lib', v == null ? name : '$name $v');
			}
			if (dce != null) add('dce', dce);
			if (analyzerOptimize) add('d', 'analyzer-optimize');
			if (esVersion != null) add('d', 'js-es$esVersion');
			for (name in flags) add('d', name);
			for (key => value in args) add(key, value);
		}

		return root;
	}

	public function output(): String return outputPath + getOutputFile();

	public function getOutputFile(): String return outputFile + outputExt();

	public function outputExt(): String {
		return switch target {
			case HaxeTargets.JS: '.js';
			case HaxeTargets.Neko: '.n';
			case HaxeTargets.Swf: '.swf';
			case HaxeTargets.Swc: '.swc';
			case HaxeTargets.HL: '.hl';
			case HaxeTargets.HLC: '.c';
		}
	}

	public function createOutputFile(file: String, template: String, ?replaces: Map<String, String>): Void {
		createOutputPathIfNeed();
		createFile(outputPath + file, template, replaces);
	}

	public function getMainhxPath(): String return cps[0];

	public function getMainhx(): String return gethx(main);

	public function gethx(name: String): String return getMainhxPath() + '/' + name + '.hx';

	public function createMainhx(template: String, ?replaces: Map<String, String>): Void {
		createPathToMainhxIfNeed();
		createFile(getMainhx(), template, replaces);
	}

	public function createEmptyMainhx(): Void {
		Utils.createEmptyMainFile(getMainhx());
	}

	public function createOutputPathIfNeed(): Void {
		if (!outputPathExists()) FileSystem.createDirectory(outputPath);
	}

	public function outputPathExists(): Bool {
		return FileSystem.exists(outputPath);
	}

	public function createOutputPath(): Void {
		FileSystem.createDirectory(outputPath);
	}

	public function createPathToMainhxIfNeed(): Void {
		if (!pathToMainhxExists()) createPathToMainhx();
	}

	public function createPathToMainhx(): Void {
		FileSystem.createDirectory(getMainhxPath());
	}

	public function pathToMainhxExists(): Bool {
		return FileSystem.exists(getMainhxPath());
	}

	private function targetKey(): String {
		return switch target {
			case HaxeTargets.Swc: 'swf';
			case HaxeTargets.HLC: 'hl';
			case t: t;
		}
	}

	private function createFile(file: String, template: String, ?replaces: Map<String, String>): Void {
		var data: String = Resource.getString(template);
		if (replaces != null) for (key => value in replaces) data = data.replace('::$key::', value);
		File.saveContent(file, data);
	}

}
