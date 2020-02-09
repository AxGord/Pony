package pony.flash.starling.utils;

/**
 * PowerOfTwo
 * @author Maletin
 */
class PowerOfTwo {

	/** Returns the next power of two that is equal to or bigger than the specified number. */
	public static function getNextPowerOfTwo(number: Float): Int {
		if (Std.is(number, Int) && number > 0 && (cast(number, Int) & (cast(number, Int) - 1)) == 0) // see: http://goo.gl/D9kPj
			return cast(number, Int);
		else {
			var result: Int = 1;
			number -= 0.000000001; // avoid floating point rounding errors

			while (result < number)
				result <<= 1;
			return result;
		}
	}

}