import sys.FileSystem;
import sys.io.File;

enum ProjectType {
	pixi;
}

class Create {

	private static inline var outputDir:String = 'bin/';

	public static function run(args:Array<String>):Void {

		var type:ProjectType = try ProjectType.createByName(args[0]) catch(_:Any) null;
		var name:String = type != null ? args[1] : args[0];

		if (FileSystem.exists(Utils.MAIN_FILE)) Utils.error(Utils.MAIN_FILE + ' exists');
				
		var content = Xml.createDocument();
		var root = Xml.createElement('project');
		if (name != null) root.set('name', name);
		switch type {
			case pixi:
				root.addChild(serverElement(true));
				//root.addChild(build);

			case null:
				root.addChild(Xml.createComment('Put configuration here'));
		}
		content.addChild(root);
		var r = '<?xml version="1.0" encoding="utf-8" ?>\n';
		r += haxe.xml.Printer.print(content, true);
		File.saveContent(Utils.MAIN_FILE, r);

		//createVscode();

	}

	private static function serverElement(httpServer:Bool):Xml {
		var r = Xml.createElement('server');
		if (httpServer) {
			r.addChild(xmlSimple('path', outputDir));
			r.addChild(xmlSimple('port', '2000'));
		}
		r.addChild(xmlSimple('haxe', '6001'));
		return r;
	}

	private static function xmlSimple(v:String, data:String):Xml {
		var e = Xml.createElement(v);
		var d = Xml.createPCData(data);
		e.addChild(d);
		return e;
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