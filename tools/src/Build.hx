import haxe.xml.Fast;
import sys.io.File;
/**
 * Build
 * @author AxGord <axgord@gmail.com>
 */
class Build {

	private var command:Array<String> = []; 
	private var debug:Bool;
	private var app:String;
	
	public function new(xml:Fast, app:String, debug:Bool) {
		this.app = app;
		this.debug = debug;
		
		if (app == null && xml.hasNode.apps) throw 'Please type app name';
		
		pushCommands(xml);
		if (debug) command.push('-debug');
		
		Sys.println('haxe ' + command.join(' '));
		
		Sys.command('haxe', command);
	}
	
	private function pushCommands(xml:Fast):Void {
		for (e in xml.elements) {
			switch e.name {
				case 'apps':
					pushCommands(e.node.resolve(app));
				case 'd':
					command.push('-D');
					if (e.has.name)
						command.push(e.att.name + '=' + e.innerData);
					else
						command.push(e.innerData);
				case 'debug': if (debug) pushCommands(e);
				case 'release': if (!debug) pushCommands(e);
				case a:
					command.push('-' + a);
					command.push(e.innerData);
			}
		}
		
	}
	
}