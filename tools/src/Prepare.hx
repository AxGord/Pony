package;
import haxe.xml.Fast;

/**
 * Prepare
 * @author AxGord <axgord@gmail.com>
 */
class Prepare {

	public function new(xml:Fast) {
		for (node in xml.node.haxelib.nodes.lib) {
			Sys.command('haxelib', ['install', node.innerData, '--always']);
		}
	}
	
}