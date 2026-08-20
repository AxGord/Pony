package pony;

/**
 * Byte
 * @author AxGord <axgord@gmail.com>
 */
abstract Byte(Int) from Int to Int {

	public static inline final b0001: Int = 1;
	public static inline final b0010: Int = 2;
	public static inline final b0100: Int = 4;
	public static inline final b1000: Int = 8;

	public var a(get, never): Int;
	public var b(get, never): Int;

	private inline function get_a(): Int return this >> 4;

	private inline function get_b(): Int return this & 0xF;

	public static inline function create(a: Int, b: Int): Byte return (a << 4) + b;

	public inline function chechSumWith(b: Byte): Byte return (this + (b: Int)) & 0xFF;

	@:to public inline function toString(): String return '0x${StringTools.hex(this)}';

}
