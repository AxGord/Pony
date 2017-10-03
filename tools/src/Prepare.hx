package;
import sys.io.File;
import haxe.xml.Fast;
using pony.text.TextTools;

/**
 * Prepare
 * @author AxGord <axgord@gmail.com>
 */
class Prepare {

	public function new(xml:Fast, app:String, debug:Bool) {
		Sys.println('update haxelib');
		for (node in xml.node.haxelib.nodes.lib) {
			var args = ['install'];
			args = args.concat(node.innerData.split(' '));
			args.push('--always');
			Sys.command('haxelib', args);
		}
		var f = false;
		if (xml.node.build.att.hxml.isTrue()) {
			var s = '';
			for (e in new Build(xml, app, debug).getCommands()) {
				s += e;
				s += f ? '\n' : ' ';
				f = !f;
			}
			File.saveContent('pony.hxml', s);
		}
	}
	
}