import haxe.xml.Fast;
import haxe.Utf8;

/**
 * Chars
 * @author AxGord <axgord@gmail.com>
 */
class Chars {

	public static function run(file:String):Void {
		var c:String = sys.io.File.getContent(file);
		var x:Fast = new Fast(Xml.parse(c));
		#if (haxe_ver >= "4.0.0")
		var chars:Array<Fast> = x.node.font.node.chars.nodes.char;
		var rs:Utf8 = new Utf8(chars.length);
		#else
		var chars:List<Fast> = x.node.font.node.chars.nodes.char;
		var rs:Utf8 = new Utf8();
		#end
		for (char in chars)
			rs.addChar(Std.parseInt(char.att.id));
		Sys.println(rs.toString());
	}

}