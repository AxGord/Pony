package pony.pixi.ui.slices;

using StringTools;

/**
 * SliceTools
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
class SliceTools {

	public static function getSliceSprite(name: String, ?useSpriteSheet: String, creep: Float = 0): SliceSprite {
		return getSliceSpriteFromData(parseSliceName(name), useSpriteSheet, creep);
	}

	public static function parseSliceName(name: String): SliceData {
		return if (check(name, 2, 'v')) SliceData.Vert2(slice(name, 2, 'v'));
			else if (check(name, 2, 'h')) SliceData.Hor2(slice(name, 2, 'h'));
			else if (check(name, 3, 'v')) SliceData.Vert3(slice(name, 3, 'v'));
			else if (check(name, 3, 'h')) SliceData.Hor3(slice(name, 3, 'h'));
			else if (check(name, 4)) SliceData.Four(slice(name, 4));
			else if (check(name, 6, 'v')) SliceData.Vert6(slice(name, 6, 'v'));
			else if (check(name, 6, 'h')) SliceData.Hor6(slice(name, 6, 'h'));
			else if (check(name, 9)) SliceData.Nine(slice(name, 9));
			else SliceData.Not(name);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function check(name: String, n: Int, letter: String = ''): Bool {
		return name.indexOf('{slice$n$letter}') != -1;
	}

	private static function slice(name: String, n: Int, letter: String = ''): Array<String> {
		var s = name.split('{slice$n$letter}');
		return [for (i in 0...n) s[0] + i + s[1]];
	}

	public static function getSliceSpriteFromData(data: SliceData, ?useSpriteSheet: String, creep: Float = 0): SliceSprite {
		return switch data {
			case SliceData.Hor2(a): new Slice2H(a, useSpriteSheet, creep);
			case SliceData.Hor3(a): new Slice3H(a, useSpriteSheet, creep);
			case SliceData.Vert2(a): new Slice2V(a, useSpriteSheet, creep);
			case SliceData.Vert3(a): new Slice3V(a, useSpriteSheet, creep);
			case SliceData.Four(a): new Slice4(a, useSpriteSheet, creep);
			case SliceData.Hor6(a): new Slice6H(a, useSpriteSheet, creep);
			case SliceData.Vert6(a): new Slice6V(a, useSpriteSheet, creep);
			case SliceData.Nine(a): new Slice9(a, useSpriteSheet, creep);
			case SliceData.Not(s): new SliceSprite([s], useSpriteSheet);
		}
	}

}