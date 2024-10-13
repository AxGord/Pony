package pony.ui.gui.slices;

using StringTools;

using pony.text.TextTools;

/**
 * SliceTools
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:nullSafety(Strict)
class SliceTools {

	public static function parseSliceName(name: String): SliceData {
		return if (check(name, 2, 'v'))
			SliceData.Vert2(slice(name, 2, 'v'));
		else if (check(name, 2, 'h'))
			SliceData.Hor2(slice(name, 2, 'h'));
		else if (check(name, 3, 'v'))
			SliceData.Vert3(slice(name, 3, 'v'));
		else if (check(name, 3, 'h'))
			SliceData.Hor3(slice(name, 3, 'h'));
		else if (check(name, 4))
			SliceData.Four(slice(name, 4));
		else if (check(name, 6, 'v'))
			SliceData.Vert6(slice(name, 6, 'v'));
		else if (check(name, 6, 'h'))
			SliceData.Hor6(slice(name, 6, 'h'));
		else if (check(name, 9))
			SliceData.Nine(slice(name, 9));
		else
			SliceData.Not(name);
	}

	public static function getType(name: String): SliceData {
		return if (check(name, 2, 'v'))
			SliceData.Vert2();
		else if (check(name, 2, 'h'))
			SliceData.Hor2();
		else if (check(name, 3, 'v'))
			SliceData.Vert3();
		else if (check(name, 3, 'h'))
			SliceData.Hor3();
		else if (check(name, 4))
			SliceData.Four();
		else if (check(name, 6, 'v'))
			SliceData.Vert6();
		else if (check(name, 6, 'h'))
			SliceData.Hor6();
		else if (check(name, 9))
			SliceData.Nine();
		else if (checkAnim(name))
			parseAnimSpeed(name);
		else
			SliceData.Not();
	}

	public static function getNames(name: String): Array<String> {
		return if (check(name, 2, 'v'))
			slice(name, 2, 'v');
		else if (check(name, 2, 'h'))
			slice(name, 2, 'h');
		else if (check(name, 3, 'v'))
			slice(name, 3, 'v');
		else if (check(name, 3, 'h'))
			slice(name, 3, 'h');
		else if (check(name, 4))
			slice(name, 4);
		else if (check(name, 6, 'v'))
			slice(name, 6, 'v');
		else if (check(name, 6, 'h'))
			slice(name, 6, 'h');
		else if (check(name, 9))
			slice(name, 9);
		else
			[name];
	}

	public static function clean(name: String): String {
		return if (check(name, 2, 'v'))
			remove(name, 2, 'v');
		else if (check(name, 2, 'h'))
			remove(name, 2, 'h');
		else if (check(name, 3, 'v'))
			remove(name, 3, 'v');
		else if (check(name, 3, 'h'))
			remove(name, 3, 'h');
		else if (check(name, 4))
			remove(name, 4);
		else if (check(name, 6, 'v'))
			remove(name, 6, 'v');
		else if (check(name, 6, 'h'))
			remove(name, 6, 'h');
		else if (check(name, 9))
			remove(name, 9);
		else if (checkAnim(name))
			removeAnim(name);
		else
			name;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function checkAnim(name: String): Bool {
		return name.indexOf('{anim') != -1;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function check(name: String, n: Int, letter: String = ''): Bool {
		return index(name, n, letter) != -1;
	}

	private static function slice(name: String, n: Int, letter: String = ''): Array<String> {
		var s: Array<String> = name.split('{slice$n$letter}');
		return [for (i in 0...n) s[0] + i + s[1]];
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function index(name: String, n: Int, letter: String = ''): Int {
		return name.indexOf('{slice$n$letter}');
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function remove(name: String, n: Int, letter: String = ''): String {
		return name.substr(0, index(name, n, letter));
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function removeAnim(name: String): String {
		var p: SPair<String> = name.firstSplit('{anim');
		return p.a + p.b.allAfter('}');
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function parseAnimSpeed(name: String): SliceData {
		var r: Null<String> = name.extract('{anim', '}');
		if (r != null) {
			var s: SPair<String> = r.firstSplit(',');
			return SliceData.Anim(Std.parseFloat(s.a), s.b != null ? s.b : null);
		} else {
			return SliceData.Anim();
		}
	}

}