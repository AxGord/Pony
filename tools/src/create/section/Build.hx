package create.section;

import types.*;

class Build extends Section {

	public var libs:Map<String, String> = new Map();
	public var target:HaxeTargets = null;
	public var outputFile:String = 'app';
	public var outputPath:String = 'bin/';
	public var hxml:Bool = true;
	public var cps:Array<String> = ['src'];
	public var main:String = 'Main';
	public var dce:String = 'full';
	public var analyzerOptimize:Bool = true;

	public function new() super('build');

	public function addLib(name:String, ?version:String):Void {
		libs[name] = version;
	}

	public function result():Xml {
		init();
		if (hxml) set('hxml', 'true');
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
		return xml;
	}

	public function output():String return outputPath + getOutputFile();
	public function getOutputFile():String return outputFile + outputExt();

	public function outputExt():String {
		return switch target {
			case HaxeTargets.JS: '.js';
			case HaxeTargets.Neko: '.n';
		}
	}

	public function getMainhx():String return cps[0] + '/' + main + '.hx';

}