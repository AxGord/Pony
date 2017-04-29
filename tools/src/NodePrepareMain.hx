#if nodejs
import sys.io.File;
import haxe.xml.Fast;
import haxe.Json;
import js.Node;

/**
 * NodePrepare
 * @author AxGord <axgord@gmail.com>
 */
class NodePrepareMain {

	static var itetator:Iterator<Fast>;
	
	private static function main() {
		var file = 'pony.xml';
		var xml = new Fast(Xml.parse(File.getContent(file)));
		itetator = xml.node.project.elements;
		runNext();
	}
	
	static function runNext():Void {
		if (!itetator.hasNext()) return;
		var e = itetator.next();
		Sys.println('Try run module ' + e.name);
		switch e.name {
			case 'poeditor':
				
				//var poe = new Poeditor(e);
				//poe.updateFiles(runNext);
				runNext();
			case 'download':
				
				var d = new Download(e);
				d.run(runNext);
				
			case _:
				runNext();
		}
	}
	
}
#end