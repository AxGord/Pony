package pony.color;

/**
 * UColor
 * Can be only positive
 * @author AxGord <axgord@gmail.com>
 */
abstract UColor(UInt) from UInt to UInt {

	public static inline var HALF_POWER: UInt = 384;
	public static inline var POS_ALPHA: UInt = 24;
	public static inline var POS_RED: UInt = 16;
	public static inline var POS_GREEN: UInt = 8;

	/**
	 * ARGB
	 */
	public var argb(get, never): UInt;

	/**
	 * RGB
	 */
	public var rgb(get, never): UInt;

	/**
	 * Alpha 0...255
	 */
	public var a(get, never): UInt;

	/**
	 * Red 0...255
	 */
	public var r(get, never): UInt;

	/**
	 * Green 0...255
	 */
	public var g(get, never): UInt;

	/**
	 * Blue 0...255
	 */
	public var b(get, never): UInt;

	/**
	 * Power
	 */
	public var power(get, never): UInt;

	/**
	 * Alpha 0...1
	 */
	public var af(get, never): Float;

	/**
	 * Red 0...1
	 */
	public var rf(get, never): Float;

	/**
	 * Green 0...1
	 */
	public var gf(get, never): Float;

	/**
	 * Blue 0...1
	 */
	public var bf(get, never): Float;

	/**
	 * This color with inverted alpha
	 */
	public var invertAlpha(get, never): UColor;

	/**
	 * Inverted color
	 */
	public var invert(get, never): UColor;

	/**
	 * White or black
	 */
	public var alternative(get, never): UColor;

	/**
	 * Construct from ARGB values
	 */
	public inline function new(v: UInt) this = v;

	/**
	 * Build from RGB values
	 */
	public static inline function fromRGB(r: UInt, g: UInt, b: UInt): UColor return (r << POS_RED) + (g << POS_GREEN) + b;

	/**
	 * Build from ARGB values
	 */
	public static inline function fromARGB(a: UInt, r: UInt, g: UInt, b: UInt): UColor
		return (a << POS_ALPHA) + (r << POS_RED) + (g << POS_GREEN) + b;

	/**
	 * Build from RGBAF values
	 */
	public static inline function fromRGBAF(rgb: UColor, af: Float): UColor
		return (lim(Std.int(af * Color.MAX_CHANNEL)) << POS_ALPHA) + (rgb.r << POS_RED) + (rgb.g << POS_GREEN) + rgb.b;

	/**
	 * Safely building from RGB values
	 * Values limited 0...255
	 */
	public static function fromRGBSave(r: Int, g: Int, b: Int): UColor {
		r = lim(r);
		g = lim(g);
		b = lim(b);
		return fromRGB(r, g, b);
	}
	/**
	 * Safely building from ARGB values
	 */
	public static function fromARGBSave(a: Int, r: Int, g: Int, b: Int): UColor {
		a = lim(a);
		r = lim(r);
		g = lim(g);
		b = lim(b);
		return fromARGB(a, r, g, b);
	}

	@:extern private inline function get_alternative(): UColor return power > HALF_POWER ? 0 : Color.WHITE;

	private static inline function lim(v: Int): UInt {
		if (v > Color.MAX_CHANNEL) v = Color.MAX_CHANNEL;
		if (v < 0x00) v = 0x00;
		return v;
	}

	private inline function _invert(v: UInt): UInt return Color.MAX_CHANNEL - v;

	private inline function get_invertAlpha(): UColor return fromARGB(_invert(a), r, g, b);
	private inline function get_invert(): UColor return fromARGB(a, _invert(r), _invert(g), _invert(b));

	private inline function get_argb(): UInt return this;
	private inline function get_rgb(): UInt return this & Color.WHITE;

	private inline function get_power(): UInt return r + g + b;

	private inline function get_a(): UInt return (this >> POS_ALPHA) & Color.MAX_CHANNEL;
	private inline function get_r(): UInt return (this >> POS_RED) & Color.MAX_CHANNEL;
	private inline function get_g(): UInt return (this >> POS_GREEN) & Color.MAX_CHANNEL;
	private inline function get_b(): UInt return this & Color.MAX_CHANNEL;
	private inline function get_af(): Float return a / Color.MAX_CHANNEL;
	private inline function get_rf(): Float return r / Color.MAX_CHANNEL;
	private inline function get_gf(): Float return g / Color.MAX_CHANNEL;
	private inline function get_bf(): Float return b / Color.MAX_CHANNEL;

	//Haxe fail!
	/*
	@:op(A + B) inline static private function addToString(a:String, b:UColor):UColor return a+b.toString();
	@:op(A + B) inline static private function addToString2(a:UColor, b:String):UColor return a.toString()+b;
	*/

	/**
	 * First color subtract second color
	 */
	@:op(A - B) private static inline function sub(a: UColor, b: UColor): Color return Color.sub(a, b);
	/**
	 * Colors sum
	 */
	@:op(A + B) private static inline function add(a: UColor, b: UColor): UColor
		return fromARGB(a.a + b.a, a.r + b.r, a.g + b.g, a.b + b.b);

	#if (HUGS && !WITHOUTUNITY)
	@:to public inline function toUnity(): unityengine.Color return new unityengine.Color(rf, gf, bf, 1 - af);
	#end

	@:op(A > B) private static inline function gt(a: UColor, b: UColor): Bool return a.power > b.power;
	@:op(A >= B) private static inline function gte(a: UColor, b: UColor): Bool return a.power >= b.power;
	@:op(A < B) private static inline function lt(a: UColor, b: UColor): Bool return a.power < b.power;
	@:op(A <= B) private static inline function lte(a: UColor, b: UColor): Bool return a.power <= b.power;

	/**
	 * Convert color to string
	 */
	@:to public inline function toString(): String return '#' + StringTools.hex(rgb, 6);

	/**
	 * Convert color to string with alpha
	 */
	public inline function toStringWithAlpha(): String return '#' + StringTools.hex(this, 8);

	/**
	 * Convert color to rgba string with inverted alpha
	 */
	public inline function toRGBAIString(): String return 'rgba(${r}, ${g}, ${b}, ${invertAlpha.af})';

	/**
	 * Convert color to rgba string
	 */
	public inline function toRGBAString(): String return 'rgba(${r}, ${g}, ${b}, ${af})';

	/**
	 * Convert color to rgb string
	 */
	public inline function toRGBString(): String return 'rgb(${r}, ${g}, ${b})';

	/**
	 * Build color from string
	 */
	@:from public static function fromString(s: String): UColor {
		s = StringTools.trim(s);
		return new UColor(
			if (s.substr(0, 1) == '#') {
				Std.parseInt('0x' + s.substr(1));
			} else if (s.substr(0, 3) == 'rgb') {
				s = StringTools.ltrim(s.substr(3));
				if (StringTools.startsWith(s, '(') && StringTools.endsWith(s, ')')) {
					var d = s.substr(1, s.length - 2).split(',').map(Std.parseInt);
					if (d.length != 3) throw 'Color params error';
					fromRGB(d[0], d[1], d[2]);
				} else throw 'Color syntax error';
			} else if (s.substr(0, 4) == 'argb') {
				s = StringTools.ltrim(s.substr(4));
				if (StringTools.startsWith(s, '(') && StringTools.endsWith(s, ')')) {
					var d = s.substr(1, s.length - 2).split(',').map(Std.parseInt);
					if (d.length != 4) throw 'Color params error';
					fromARGB(d[0], d[1], d[2], d[3]);
				} else throw 'Color syntax error';
			} else switch s {
				case 'red': Color.RED;
				case 'green': Color.GREEN;
				case 'blue': Color.BLUE;
				case _: throw 'Unknown color';
			}
		);
	}

}