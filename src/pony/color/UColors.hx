package pony.color;

using pony.math.MathTools;
using Std;

/**
 * Colors
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:forward(push, pop, iterator, length)
abstract UColors(Array<UColor>) from Array<UColor> to Array<UColor> {

	/**
	 * Middle color
	 */
	public var mid(get, never): UColor;

	/**
	 * Middle color with inverted alpha
	 */
	public var midInvertAlpha(get, never): UColor;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_mid(): UColor return _mid(0);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_midInvertAlpha(): UColor return _mid(Color.MAX_CHANNEL);

	private function _mid(alp: UInt): UColor {
		var r: Array<UInt> = [];
		var g: Array<UInt> = [];
		var b: Array<UInt> = [];
		for (e in this) if (e.a == alp) {
			r.push(e.r);
			g.push(e.g);
			b.push(e.b);
		}
		return Color.fromRGB(r.arithmeticMean().int(), g.arithmeticMean().int(), b.arithmeticMean().int());
	}

	/**
	 * Build from iterable colors
	 */
	@:from public static inline function fromIterable(it: Iterable<UColor>): UColors return Lambda.array(it);

	/**
	 * Build from iterable UInt
	 */
	@:from public static inline function fromIterableUInt(it: Iterable<UInt>): UColors return Lambda.array(it);

	#if (flash && !doc_gen)
	@:from public static inline function fromVector(a: flash.Vector<UInt>): UColors return [ for (i in 0...a.length) a[i] ];
	#end

	@:from #if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromString(s: String): UColors return s.split(' ').map(UColor.fromString);

}