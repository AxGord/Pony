package create.ides;

import sys.FileSystem;
import pony.text.XmlTools;

class HaxeDevelop {

	public static function create(name:String, main:String, libs:Map<String, String>, cps:Array<String>, ponycmd:String = 'build'):Void {
		if (name == null) return;
		var fdname = name + '.hxproj';
		if (!FileSystem.exists(fdname)) {
			var fcmd = 'build.cmd';

			var root = Xml.createElement('project');
			root.set('version', '2');

			root.addChild(XmlTools.mapToNode('output', 'movie', [
				'outputType' => 'CustomBuild',
				'input' => '',
				'path' => 'null',
				'fps' => '0',
				'width' => '0',
				'height' => '0',
				'version' => '0',
				'minorVersion' => '0',
				'platform' => 'Custom',
				'background' => '#FFFFFF'
			]));

			var clp = XmlTools.mapToNode('classpaths', 'class', [for (cp in cps) 'path' => cp]);
			clp.addChild(Xml.createComment('example: <class path="..." />'));
			root.addChild(clp);

			root.addChild(XmlTools.mapToNode('build', 'option', [
				'directives' => '',
				'flashStrict' => 'False',
				'noInlineOnDebug' => 'False',
				'mainClass' => '',
				'enabledebug' => 'False',
				'additional' => 'pony.hxml'
			]));

			var libs = XmlTools.mapToNode('haxelib', 'library', [
				for (lib in libs.keys()) 'name' => lib +
					(
					libs[lib] == null
					? ''
					: (':' + libs[lib])
					)
			]);
			libs.addChild(Xml.createComment('example: <library name="..." />'));
			root.addChild(libs);

			root.addChild(XmlTools.mapToNode('compileTargets', 'compile', [
				'path' => main
			]));

			root.addChild(XmlTools.mapToNode('hiddenPaths', 'hidden', [
				'path' => 'obj'
			]));

			root.addChild(XmlTools.node('preBuildCommand', '$fcmd $(BuildConfig)'));

			root.addChild(XmlTools.att('postBuildCommand', 'alwaysRun', 'False'));

			root.addChild(XmlTools.mapToNode('options', 'option', [
				'showHiddenPaths' => 'True',
				'testMovie' => 'Webserver',
				'testMovieCommand' => ''
			]));

			root.addChild(Xml.createElement('storage'));

			Utils.saveXML(fdname, root);

			sys.io.File.saveContent(fcmd, 'pony $ponycmd %1');

		}
	}

}