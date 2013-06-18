package pony.macro;

import haxe.macro.Context;
import haxe.xml.Fast;
import sys.FileSystem;
import sys.io.File;
/**
 * [haxe --macro pony.macro.Cmd...]
 * @author AxGord
 */
class Cmd {
	
	/**
	 * Include files marked as Always Compile
	 * @param	file FD project file
	 */
	public static function fd(file:String):Void {
		var x:Fast = new Fast(Xml.parse(File.getContent(file)));
		var cp = Context.getClassPath();
		for (n in x.node.project.node.compileTargets.nodes.compile) {
			var s = StringTools.replace(n.att.path, '\\', '/');
			for (e in cp) s = StringTools.replace(s, e, '');
			s = StringTools.replace(s, '/', '.');
			Context.getModule(s.substr(0, s.length - 3));
		}
	}
	
}