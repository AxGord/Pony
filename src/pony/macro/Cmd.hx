package pony.macro;

#if (macro || dox)
import haxe.macro.Context;
import haxe.xml.Fast;
import sys.FileSystem;
import sys.io.File;

using StringTools;

/**
 * [haxe --macro pony.macro.Cmd...]
 * @author AxGord
 */
class Cmd {

	/**
	 * Include files marked as Always Compile
	 * @param	file FD project file
	 */
	public static function fd(file: String): Void {
		final x: Fast = new Fast(Xml.parse(File.getContent(file)));
		final cp: Array<String> = Context.getClassPath();
		for (n in x.node.project.node.compileTargets.nodes.compile) {
			var s: String = StringTools.replace(n.att.path, '\\', '/');
			for (e in cp) s = s.replace(e, '');
			s = s.replace('/', '.');
			Context.getModule(s.substr(0, s.length - 3));
		}
	}

}
#end
