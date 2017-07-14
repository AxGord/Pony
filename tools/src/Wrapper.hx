package;
import haxe.xml.Fast;
import sys.io.File;

/**
 * Wrapper
 * @author AxGord <axgord@gmail.com>
 */
class Wrapper {
	
	private var debug:Bool;
	private var app:String;
	private var pre:String;
	private var post:String;
	private var file:String;

	public function new(xml:Fast, app:String, debug:Bool) {
		//Sys.println('Wrapper');
		this.app = app;
		this.debug = debug;
		
		if (app == null && xml.hasNode.apps) throw 'Please type app name';
		
		pushCommands(xml);
		
		if (file == null) throw 'File not set';
		if (pre == null && post == null) {
			//Sys.println('Nothing');
			return;
		}
		
		var data = File.getContent(file);
		
		if (pre != null) data = pre + data;
		if (post != null) data = data + post;
		
		Sys.println('Apply wrapper to ' + file);
		
		File.saveContent(file, data);
	}
	
	private function pushCommands(xml:Fast):Void {
		for (e in xml.elements) {
			switch e.name {
				case 'apps':
					pushCommands(e.node.resolve(app));
				case 'debug': if (debug) pushCommands(e);
				case 'release': if (!debug) pushCommands(e);
				case 'pre':
					pre = e.innerData;
				case 'post':
					post = e.innerData;
				case 'file':
					file = e.innerData;
			}
		}
		
	}
	
}