package pony.color;

typedef ColorImpl = {
	a: Int,
	r: Int,
	g: Int,
	b: Int
}

/**
 * Color, can be negative
 * @author AxGord <axgord@gmail.com>
 */
abstract Color(ColorImpl) {

	public static inline var MAX_CHANNEL: Int = 0xFF;
	public static inline var WHITE: UInt = 0xFFFFFF;
	public static inline var RED: UInt = 0xFF0000;
	public static inline var GREEN: UInt = 0x00FF00;
	public static inline var BLUE: UInt = 0x0000FF;

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
	public var a(get, never): Int;

	/**
	 * Red 0...255
	 */
	public var r(get, never): Int;

	/**
	 * Green 0...255
	 */
	public var g(get, never): Int;

	/**
	 * Blue 0...255
	 */
	public var b(get, never): Int;

	/**
	 * Power
	 */
	public var power(get, never): Int;

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
	public var invertAlpha(get, never): Color;

	/**
	 * Inverted color
	 */
	public var invert(get, never): Color;

	/**
	 * Construct from ARGB values
	 */
	public inline function new(a: Int, r: Int, g: Int, b: Int) this = {a: a, r: r, g: g, b: b};

	/**
	 * Build from RGB values
	 */
	public static inline function fromRGB(r: Int, g: Int, b: Int): Color return new Color(0, r, g, b);

	/**
	 * Build from ARGB values
	 */
	public static inline function fromARGB(a: Int, r: Int, g: Int, b: Int): Color return new Color(a, r, g, b);

	/**
	 * Safely building from RGB values
	 * Values limited -255...255
	 */
	public static function fromRGBSave(r: Int, g: Int, b: Int): Color {
		r = lim(r);
		g = lim(g);
		b = lim(b);
		return fromRGB(r, g, b);
	}

	/**
	 * Safely building from ARGB values
	 */
	public static function fromARGBSave(a: Int, r: Int, g: Int, b: Int): Color {
		a = lim(a);
		r = lim(r);
		g = lim(g);
		b = lim(b);
		return fromARGB(a, r, g, b);
	}

	private static inline function lim(v: Int): Int {
		if (v > MAX_CHANNEL) v = MAX_CHANNEL;
		else if (v < -MAX_CHANNEL) v = -MAX_CHANNEL;
		return v;
	}

	private inline function _invert(v: Int): Int return MAX_CHANNEL - v;

	private inline function get_invertAlpha(): Color return fromARGBSave(_invert(a), r, g, b);
	private inline function get_invert(): Color return fromARGBSave(a, _invert(r), _invert(g), _invert(b));

	@:from private static inline function fromUInt(v: UInt): Color return fromUColor(new UColor(v));

	@:from private static inline function fromUColor(v: UColor): Color
		return new Color(Std.int(v.a), Std.int(v.r), Std.int(v.g), Std.int(v.b));

	@:to public inline function toUColor(): UColor return UColor.fromARGBSave(a, r, g, b);

	@:to private inline function get_argb(): UInt return toUColor();
	private inline function get_rgb(): UInt return toUColor().rgb;

	private inline function get_power(): Int return r + g + b;

	private inline function get_a(): Int return this.a;
	private inline function get_r(): Int return this.r;
	private inline function get_g(): Int return this.g;
	private inline function get_b(): Int return this.b;

	private inline function get_af(): Float return a / MAX_CHANNEL;
	private inline function get_rf(): Float return r / MAX_CHANNEL;
	private inline function get_gf(): Float return g / MAX_CHANNEL;
	private inline function get_bf(): Float return b / MAX_CHANNEL;

	/**
	 * Convert color to string
	 */
	@:to public inline function toString(): String return toUColor();

	/**
	 * Build color from string
	 */
	@:from public static inline function fromString(s: String): Color return UColor.fromString(s);

	/**
	 * First color subtract second color
	 */
	@:op(A - B) public static inline function sub(a: Color, b: Color): Color
		return fromARGBSave(a.a - b.a, a.r - b.r, a.g - b.g, a.b - b.b);

	/**
	 * Colors sum
	 */
	@:op(A + B) public static inline function add(a: Color, b: Color): Color
		return fromARGBSave(a.a + b.a, a.r + b.r, a.g + b.g, a.b + b.b);

	// @:op(A + B) inline static public function add1(a: UColor, b: Color): Color
	// 	return UColor.fromARGBSave(a.a + b.a, a.r + b.r, a.g + b.g, a.b + b.b);
	// @:op(A + B) inline static public function add2(a: Color, b: UColor): Color
	// 	return UColor.fromARGBSave(a.a + b.a, a.r + b.r, a.g + b.g, a.b + b.b);

	/**
	 * Apply bright to this color
	 */
	public inline function bright(v: Int): Color return fromARGBSave(a, r + v, g + v, b + v);

}