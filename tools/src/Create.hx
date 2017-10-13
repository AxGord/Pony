import sys.FileSystem;
import sys.io.File;

enum ProjectType {
	pixi;
}

class Create {

	private static inline var outputDir:String = 'bin/';
	private static inline var outputFile:String = 'app';

	public static function run(args:Array<String>):Void {

		var type:ProjectType = try ProjectType.createByName(args[0]) catch(_:Any) null;
		var name:String = type != null ? args[1] : args[0];

		//if (FileSystem.exists(Utils.MAIN_FILE)) Utils.error(Utils.MAIN_FILE + ' exists');
				
		var content = Xml.createDocument();
		var root = Xml.createElement('project');
		if (name != null) root.set('name', name);
		switch type {
			case pixi:
				root.addChild(serverElement(true));
				
				var download = Xml.createElement('download');
				download.set('path', 'jslib/');
				var unit = Xml.createElement('unit');
				unit.set('url', 'https://raw.githubusercontent.com/stacktracejs/stacktrace.js/v{v}/dist/stacktrace.min.js');
				unit.set('v', '1.3.0');
				download.addChild(unit);
				var unit = Xml.createElement('unit');
				unit.set('url', 'https://pixijs.download/v{v}/pixi.min.js');
				unit.set('check', 'pixi.js - v{v}');
				unit.set('v', '4.5.3');
				download.addChild(unit);
				root.addChild(download);

				var haxelib = Xml.createElement('haxelib');
				haxelib.addChild(Utils.xmlSimple('lib', 'pixijs 4.5.5'));
				haxelib.addChild(Utils.xmlSimple('lib', 'pony 0.4.7'));
				root.addChild(haxelib);

				var build = Xml.createElement('build');
				build.set('hxml', 'true');
				build.addChild(Utils.xmlSimple('js', outputDir + outputFile + '.js'));
				build.addChild(Utils.xmlSimple('cp', 'src'));
				build.addChild(Utils.xmlSimple('main', 'Main'));
				build.addChild(Utils.xmlSimple('dce', 'full'));
				build.addChild(Utils.xmlSimple('d', 'analyzer-optimize'));
				root.addChild(build);

			case null:
				root.addChild(Xml.createComment('Put configuration here'));
		}
		content.addChild(root);
		
		Utils.savePonyProject(content);
		//createVscode();

	}

	private static function serverElement(httpServer:Bool):Xml {
		var r = Xml.createElement('server');
		if (httpServer) {
			r.addChild(Utils.xmlSimple('path', outputDir));
			r.addChild(Utils.xmlSimple('port', '2000'));
		}
		r.addChild(Utils.xmlSimple('haxe', '6001'));
		return r;
	}

	private static function createVscode():Void {
		if (!FileSystem.exists('.vscode')) {
			FileSystem.createDirectory('.vscode');
			var data = {
				version: '2.0.0',
				tasks: {
					taskName: 'pony build',
					type: 'shell',
					command: 'pony build',
					problemMatcher: ["$haxe"],
					group: {
						kind: 'build',
						isDefault: true
					}
				}
			};
			
		}
	}


}