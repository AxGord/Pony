package pony.geom;

using StringTools;

/**
 * Orientation
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract Orientation(UInt) to UInt {

	@SuppressWarnings('checkstyle:MagicNumber')
	public var None = 0x0000;

	@SuppressWarnings('checkstyle:MagicNumber')
	public var Horizontal = 0x0011;

	@SuppressWarnings('checkstyle:MagicNumber')
	public var Vertical = 0x1100;

	@SuppressWarnings('checkstyle:MagicNumber')
	public var Any = 0x1111;

	public var isHorizontal(get, never): Bool;
	public var isVertical(get, never): Bool;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_isHorizontal(): Bool return this & Horizontal != 0;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_isVertical(): Bool return this & Vertical != 0;

	public inline function checkDirection(d: Direction): Bool return this & d != 0;

	@:to public function toString(): String {
		return switch this {
			case None: 'None';
			case Horizontal: 'Horizontal';
			case Vertical: 'Vertical';
			case Any: 'Any';
			case _: throw 'Error';
		}
	}

	@:from public static function fromString(s: String): Orientation {
		return switch s.trim().toLowerCase() {
			case 'none', 'n': None;
			case 'horizontal', 'hor', 'h': Horizontal;
			case 'vertical', 'vert', 'v': Vertical;
			case 'any', 'a': Any;
			case _: throw "Can't get orientation";
		}
	}

}