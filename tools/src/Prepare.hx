package;
import haxe.xml.Fast;

/**
 * Prepare
 * @author AxGord <axgord@gmail.com>
 */
class Prepare {

	public function new(xml:Fast, app:String, debug:Bool) {
		if (sys.FileSystem.exists('libcache.js')) sys.FileSystem.deleteFile('libcache.js');
		if (xml.hasNode.haxelib) {
			Sys.println('update haxelib');
			for (node in xml.node.haxelib.nodes.lib) {
				var args = ['install'];
				args = args.concat(node.innerData.split(' '));
				args.push('--always');
				Sys.command('haxelib', args);
			}
		}
		if (xml.hasNode.texturepacker) {
			new Texturepacker(xml.node.texturepacker, app, debug);
		}
		if (app != null)
			new Build(xml, app, debug).writeConfigIfNeed();
	}
	
}