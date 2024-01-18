package pony;

import pony.geom.Direction;

/**
 * Random
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:nullSafety(Strict) class Random {

	public static inline function uint(to: UInt, from: UInt = 0): UInt
		return from >= to ? to : from + Std.int((to - from + 1) * Math.random());

	public static inline function int(to: Int, from: Int = 0): Int
		return from >= to ? to : from + Std.int((to - from + 1) * Math.random());

	public static inline function fromArray<T>(a: Array<T>): Null<T>
		return a[uint(a.length - 1)];

	public static inline function getFromArray<T>(a: Array<T>, count: UInt): Array<T>
		return @:nullSafety(Off) [ while (count-- > 0 && a.length > 0) a.splice(uint(a.length - 1), 1).pop() ];

	public static function genUniqueUIntArray(to: UInt, from: UInt = 0): Array<UInt>
		return shuffleArrayMod([ for (i in from...to) i ]);

	public static function genUniqueIntArray(to: Int, from: Int = 0): Array<Int>
		return shuffleArrayMod([ for (i in from...to) i ]);

	public static inline function shuffleArray<T>(a: Array<T>): Array<T>
		return shuffleArrayMod(a.copy());

	public static function shuffleArrayMod<T>(a: Array<T>): Array<T>
		return @:nullSafety(Off) [ while (a.length > 0) a.splice(uint(a.length - 1), 1).pop() ];

	public static function shuffleString(s: String): String {
		var a: Array<UInt> = [ for (i in 0...s.length) i ];
		var r: String = '';
		while (a.length > 0) r += @:nullSafety(Off) s.charAt(a.splice(uint(a.length - 1), 1).pop());
		return r;
	}

	public static function randomString(len: Int = 36): String {
		var chars: String = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz';
		var randomstring: String = '';
		for (i in 0...len) randomstring += chars.charAt(uint(chars.length - 1));
		return randomstring;
	}

	public static inline function direction(): Direction return 1 << uint(3);
	public static inline function bool(): Bool return Math.random() > 0.5;

}