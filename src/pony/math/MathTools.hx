package pony.math;

/**
 * MathTools
 * @author AxGord <axgord@gmail.com>
 */
class MathTools {

	/**
	 * The largest representable 32-bit signed integer, which is 2,147,483,647
	 */
	public static inline var MAX_INT: Int = 2147483647;

	/**
	 * The smallest representable 32-bit signed integer, which is -2,147,483,648
	 */
	public static inline var MIN_INT: Int = -2147483648;

	/**
	 * The largest representable 32-bit unsigned integer, which is 4,294,967,295
	 */
	public static inline var MAX_UINT: UInt = MAX_INT * 2 + 1;

	public static var DEG2RAD: Float = Math.PI / 180;
	public static var RAD2DEG: Float = 180 / Math.PI;

	public static function arithmeticMean(a: Iterable<Float>): Float {
		var s: Float = 0;
		var count: UInt = 0;
		for (e in a) {
			count++;
			s += e;
		}
		return s / count;
	}

	public static function arraySum<T: Float>(a: Iterable<T>): T {
		var s: T = cast 0;
		for (e in a) s += e;
		return s;
	}

	@:extern public static inline function percentCalc(p: Float, min: Float, max: Float): Float
		return (max - min) * p + min;

	@:extern public static inline function percentBackCalc(p: Float, min: Float, max: Float): Float
		return (p - min) / (max - min);

	@:extern public static inline function percentCalcd(p: Float, a: Float, b: Float): Float
		return a > b ? percentCalc(p, b, a) : percentCalc(p, a, b);

	@:extern public static inline function inRange(v: Float, min: Float, max: Float): Bool
		return min <= v && v <= max;

	@:extern public static inline function approximately(a: Float, b: Float, range: Float = 1): Bool
		return inRange(a, b - range, b + range);

	@:extern public static inline function limit(v: Float, min: Float, max: Float): Float
		return if (v < min) min; else if (v > max) max; else v;

	@:extern public static inline function cultureAdd(a: Float, b: Float, max: Float): Float
		return a + b >= max ? max : a + b;

	@:extern public static inline function cultureSub(a: Float, b: Float, min: Float): Float
		return a - b <= min ? min : a - b;

	@:extern public static inline function cultureTarget(a: Float, b: Float, step: Float): Float
		return a > b ? cultureSub(a, step, b) : cultureAdd(a, step, b);

	@:extern public static inline function midValue(a: Float, b: Float, aCount: Float, bCount: Float): Float
		return (aCount * a + bCount * b) / (aCount + bCount);

	public static inline function cabs(v: Int): Int
		return v < 0 ? -v : v;

	public static inline function cmin(a: Int, b: Int): Int
		return a < b ? a : b;

	public static inline function cmax(a: Int, b: Int): Int
		return a > b ? a : b;

	public static inline function pcMinMax(a: SPair<Int>, b: SPair<Int>): SPair<Int>
		return new SPair<Int>(cmin(a.a, b.a), cmax(b.a, b.b));

	@:extern public static inline function roundTo(v: Float, count: Int): Float
		return Math.round(v * Math.pow(10, count)) / Math.pow(10, count);

	@:extern public static inline function intTo(v: Float, count: Int): Float
		return Std.int(v * Math.pow(10, count)) / Math.pow(10, count);

	@:extern public static inline function intNot(v: Int): Int
		return v == 0 ? 1 : 0;

	public static inline function float10(v: Float): Float return intTo(v, 1);
	public static inline function float100(v: Float): Float return intTo(v, 2);
	public static inline function float1000(v: Float): Float return intTo(v, 3);
	public static inline function formatPercent(v: Float): String return float100(v * 100) + '%';

	public static inline function lengthBeforeComma(v: Float): Int
		return Std.string(v).split('.')[0].length;

	public static inline function lengthAfterComma(v: Float): Int {
		var a: Array<String> = Std.string(v).split('.');
		return a.length < 2 ? 0 : a[1].length;
	}

	public static function range(a: Float, b: Float): Float {
		var max: Float = Math.max(a, b);
		var min: Float = Math.min(a, b);
		var up: Float = min < 0 ? -min : 0;
		max += up;
		min += up;
		return max - min;
	}

	public static function shortValue(value: Int): String {
		var s: String = Std.string(value);
		var count: Int = Std.int((s.length - 1) / 3);
		var sub: String = s.substr(0, s.length - 3 * count);
		return sub + switch count {
			case 0: '';
			case 1: 'k';
			case 2: 'm';
			case 3: 'b';
			case 4: 't';
			case _: throw 'long';
		}
	}

	public static function clipSmoothOdd(n: Int, count: Int): Map<Int, Int> {
		var f: Array<Int> = clipSmoothFrames(n, count);
		return [for (e in clipSmoothOddPlan(n, count)) e => f.shift()];
	}

	public static function clipSmoothOddSimple(n: Int, count: Int): Map<Int, Int> {
		var f: Array<Int> = clipSmoothFrames(n, count);
		return [for (e in clipSmoothOddPlanSimple(n, count)) e => f.shift()];
	}

	public static function clipSmooth(n: Int, count: Int): Map<Int, Int> {
		var f: Array<Int> = clipSmoothFrames(n, count);
		return [for (i in 0...3) i => f.shift()];
	}

	public static function clipSmoothFrames(a: Int, count: Int): Array<Int> {
		var b: Int = a + 1;
		if (b >= count) b -= count;
		var c: Int = b + 1;
		if (c >= count) c -= count;
		return [a, b, c];
	}

	public static function clipSmoothOddPlan(n: Int, count: Int): Array<Int> {
		var odd: Int = n % 2;
		return if (n == count - 2) {
			[odd, odd + 1, (1 - odd) * 2];
		} else if (n == count - 1) {
			[odd, 2 - odd * 2, 3];
		} else {
			[odd, 1 - odd, odd + 2];
		}
	}

	public static function clipSmoothOddPlanSimple(n: Int, count: Int): Array<Int> {
		var p: Array<Int> = clipSmoothOddPlan(n, count);
		p.pop();
		return p;
	}

}