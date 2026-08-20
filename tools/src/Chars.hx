import pony.Fast;
import sys.io.File;

/**
 * Chars
 * @author AxGord <axgord@gmail.com>
 */
class Chars {

	public static function run(file: String): Void {
		final c: String = File.getContent(file);
		final x: Fast = new Fast(Xml.parse(c));
		#if (haxe_ver >= 4.000)
		final chars: Array<Fast> = x.node.font.node.chars.nodes.char;
		final rs: neko.Utf8 = new neko.Utf8(chars.length);
		#else
		final chars: List<Fast> = x.node.font.node.chars.nodes.char;
		final rs: haxe.Utf8 = new haxe.Utf8();
		#end
		for (char in chars) rs.addChar(Std.parseInt(char.att.id));
		Sys.println(rs.toString());
	}

}
