package create.ides;

import sys.FileSystem;

class HaxeDevelop {

	public static function create(name:String, main:String, libs:Map<String, String>, cps:Array<String>):Void {
		if (name == null) return;
		var fdname = name + '.hxproj';
		if (!FileSystem.exists(fdname)) {
			var fcmd = 'build.cmd';

			var root = Xml.createElement('project');
			root.set('version', '2');

			root.addChild(Utils.mapToNode('output', 'movie', [
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

			var clp = Utils.mapToNode('classpaths', 'class', [for (cp in cps) 'path' => cp]);
			clp.addChild(Xml.createComment('example: <class path="..." />'));
			root.addChild(clp);

			root.addChild(Utils.mapToNode('build', 'option', [
				'directives' => '',
				'flashStrict' => 'False',
				'noInlineOnDebug' => 'False',
				'mainClass' => '',
				'enabledebug' => 'False',
				'additional' => 'pony.hxml'
			]));

			var libs = Utils.mapToNode('haxelib', 'library', [
				for (lib in libs.keys()) 'name' => lib +
					(
					libs[lib] == null
					? ''
					: (':' + libs[lib])
					)
			]);
			libs.addChild(Xml.createComment('example: <library name="..." />'));
			root.addChild(libs);

			root.addChild(Utils.mapToNode('compileTargets', 'compile', [
				'path' => main
			]));

			root.addChild(Utils.mapToNode('hiddenPaths', 'hidden', [
				'path' => 'obj'
			]));

			root.addChild(Utils.xmlSimple('preBuildCommand', '$fcmd $(BuildConfig)'));

			root.addChild(Utils.xmlSimpleAtt('postBuildCommand', 'alwaysRun', 'False'));

			root.addChild(Utils.mapToNode('options', 'option', [
				'showHiddenPaths' => 'True',
				'testMovie' => 'Webserver',
				'testMovieCommand' => ''
			]));

			root.addChild(Xml.createElement('storage'));

			Utils.saveXML(fdname, root);

			sys.io.File.saveContent(fcmd, 'pony build %1');

		}
	}

}