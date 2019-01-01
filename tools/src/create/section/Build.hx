package create.section;

import pony.text.XmlTools;
import types.*;

/**
 * Build
 * @author AxGord <axgord@gmail.com>
 */
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
	public var esVersion:Int = null;

	public function new() super('build');

	public function addLib(name:String, ?version:String):Void {
		libs[name] = version;
	}

	public function getDep():Array<String> {
		return hxml ? [outputFile + '.hxml'] : [];
	}

	public function result():Xml {
		init();

		if (hxml) {
			var prepare = Xml.createElement('prepare');
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

			xml.addChild(prepare);

			var build = Xml.createElement('build');
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
		}

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

	public function getMainhx():String return gethx(main);
	public function gethx(name:String):String return cps[0] + '/' + name + '.hx';

}