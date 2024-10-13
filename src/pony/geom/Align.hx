package pony.geom;

/**
 * Align
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:nullSafety(Strict)
abstract Align(AlignType) from AlignType to AlignType {

	public var vertical(get, never): VAlign;
	public var horizontal(get, never): HAlign;
	public var defaultCenter(get, never): Align;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function new(v: AlignType) this = v;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function createDefaultCenter(): Align return new Pair(VAlign.Middle, HAlign.Center);

	@:from #if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromV(v: VAlign): Align {
		return new Pair(v, HAlign.Center);
	}

	@:from #if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromH(v: HAlign): Align {
		return new Pair(VAlign.Middle, v);
	}

	@:to #if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function toV(): VAlign return this.a;

	@:to #if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function toH(): HAlign return this.b;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_vertical(): VAlign return this.a;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_horizontal(): HAlign return this.b;

	private inline function get_defaultCenter(): Align {
		return new Pair(vertical == null ? VAlign.Middle : vertical, horizontal == null ? HAlign.Center : horizontal);
	}

	@:from public static inline function fromString(s: String): Null<Align> {
		if (s == null) return null;
		var hor: Null<HAlign> = null;
		var vert: Null<VAlign> = null;
		for (v in s.split(' ')) if (v != '') {
			switch v.toLowerCase() {
				case 'left': hor = HAlign.Left;
				case 'center': hor = HAlign.Center;
				case 'right': hor = HAlign.Right;
				case 'top': vert = VAlign.Top;
				case 'middle': vert = VAlign.Middle;
				case 'bottom': vert = VAlign.Bottom;
				case _: throw 'error';
			}
		}
		return new Pair(vert, hor);
	}

	@:to #if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function toInt(): Int return vertical.getIndex() + (1 + horizontal.getIndex()) * 3;

	@:from #if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromInt(v: Int): Align {
		return new Pair(VAlign.createByIndex(v % 3), HAlign.createByIndex(Std.int(v / 3) - 1));
	}

}

typedef AlignType = Pair<VAlign, HAlign>;

enum VAlign {
	Top; Middle; Bottom;
}

enum HAlign {
	Left; Center; Right;
}