#if nodejs
import haxe.Json;
import haxe.xml.Fast;
import js.Node;
import sys.io.File;

/**
 * Poeditor
 * @author AxGord <axgord@gmail.com>
 */
class WatchMain {

	static function main() {
		Sys.println('Start Pony watch');
		Node.setTimeout(function(){}, 3000);
		Node.process.on('uncaughtException', function(err) trace(err));
		
		var file = 'pony.xml';
		
		var xml = new Fast(Xml.parse(File.getContent(file)));
		for (e in xml.node.project.elements) {
			switch e.name {
				
				//case 'poeditor':
					
					//trace('Begin watch poeditor');
					
					
				case _:
			}
		}
		
		
	}
	
}
#end