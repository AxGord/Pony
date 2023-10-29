package pony.time;

import pony.math.MathTools;

using Std;
using StringTools;
using pony.Tools;

/**
 * Time
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:nullSafety(Strict) abstract Time(Int) from Int to Int {

	public var ms(get, never): Int;
	public var seconds(get, never): Int;
	public var minutes(get, never): Int;
	public var hours(get, never): Int;
	public var days(get, never): Int;

	public var totalMs(get, never): Int;
	public var totalSeconds(get, never): Int;
	public var totalMinutes(get, never): Int;
	public var totalHours(get, never): Int;

	public var neg(get, never): Bool;
	public var minimalPoint(get, never): Int;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function new(ms: Int) this = ms;

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromFloat(ms: Null<Float>): Time return new Time(@:nullSafety(Off) ms.int());

	@:from public static function fromString(time: String): Time {
		if (time == null) return 0;
		var ms: Int = 0;
		time = time.trim();
		var neg: Bool = time.charAt(0) == '-';
		if (neg) time = time.substr(1);
		var nbuf: String = '';
		var chbuf: String = '';
		for (i in 0...time.length) {
			var ch: String = time.charAt(i);
			if (ch == ' ') {
				continue;
			} else if (ch.parseInt() == null) {
				chbuf += ch;
			} else {
				if (chbuf != '') {
					ms += @:nullSafety(Off) parseBuf(chbuf, nbuf.parseInt());
					nbuf = '';
					chbuf = '';
				}
				nbuf += ch;
			}
		}

		if (chbuf != '' && nbuf != '') ms += @:nullSafety(Off) parseBuf(chbuf, nbuf.parseInt());

		if (ms == 0) {
			var s: Array<String> = time.split('.');
			if (s.length == 2) {
				@:nullSafety(Off) ms = s[1].parseInt();
				time = s[0];
			}
			var s: Array<String> = time.split(' ');
			var t: String;
			if (s.length == 2) {
				@:nullSafety(Off) ms += fromDays(s[0].parseInt());
				t = s[1];
			} else {
				t = time;
			}
			ms += @:nullSafety(Off) parseTime(t.split(':'));
		}
		if (neg) ms *= -1;
		return new Time(ms);
	}

	private static function parseBuf(buf: String, n: Int): Int {
		return switch buf {
			case 'ms' | 'millisecond' | 'milliseconds':
				n;
			case 's' | 'sec' | 'second' | 'seconds':
				fromSeconds(n);
			case 'm' | 'min' | 'minute' | 'minutes':
				fromMinutes(n);
			case 'h' | 'hour' | 'hours':
				fromHours(n);
			case 'd' | 'day' | 'days':
				fromDays(n);
			default: 0;
		}
	}

	@:nullSafety(Off)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function parseTime(d: Array<String>): Int {
		return switch d.length {
			case 1: fromSeconds(d[0] == '' ? 0 : d[0].parseInt());
			case 2: fromSeconds(d[1] == '' ? 0 : d[1].parseInt()) + fromMinutes(d[0] == '' ? 0 : d[0].parseInt());
			case 3:
				fromSeconds(d[2] == '' ? 0 : d[2].parseInt()) +
				fromMinutes(d[0] == '' ? 0 : d[1].parseInt()) +
				fromHours(d[0] == '' ? 0 : d[0].parseInt());
			default: throw 'Invalid time format';
		}
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function create(days: Int, hours: Int, minutes: Int, seconds: Int): Time {
		return fromDays(days) + fromHours(hours) + fromMinutes(minutes) + fromSeconds(seconds);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function createft(days: String, hours: String, minutes: String, seconds: String): Time {
		return @:nullSafety(Off) create(days.parseInt(), hours.parseInt(), minutes.parseInt(), seconds.parseInt());
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_ms(): Int return this % 1000;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_seconds(): Int return totalSeconds % 60;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_minutes(): Int return totalMinutes % 60;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_hours(): Int return totalHours % 24;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_days(): Int return (totalHours / 24).int();

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_totalMs(): Int return this;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_totalSeconds(): Int return (this / 1000).int();

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_totalMinutes(): Int return (totalSeconds / 60).int();

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_totalHours(): Int return (totalMinutes / 60).int();

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_neg(): Bool return this < 0;

	public static inline function fromDays(day: Int): Time return fromHours(day * 24);
	public static inline function fromHours(hours: Int): Time return fromMinutes(hours * 60);
	public static inline function fromMinutes(minutes: Int): Time return fromSeconds(minutes * 60);
	public static inline function fromSeconds(seconds: Int): Time return seconds * 1000;

	@:to
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function toFloat(): Float return this;
	@:to
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function toArray(): Array<Int> return [days, hours, minutes, seconds, ms];

	#if !macro
	@:to public function toString(): String {
		var s = '';
		if (this < 0) s += '-';
		if (days != 0) s += Math.abs(days) + ' ';
		s += clock();
		if (ms != 0) s += '.' + Math.abs(ms).toFixed('000');
		return s == '' ? '0' : s;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function showMinSec(): String return print(minutes) + ':' + print(seconds);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function showSec(): String return print(totalSeconds);

	public function clock(autoHide: Bool = false): String {
		var s: String = '';
		if (hours != 0 || !autoHide) {
			s += print(hours) + ':' + showMinSec();
		} else {
			if (minutes != 0) {
				s += showMinSec();
			} else if (seconds != 0) s += Math.abs(seconds);
		}
		return s;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function print(v: Float): String return Math.abs(v).toFixed('00');
	#end

	@:op(A + B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function add(a: Time, b: Time): Time return (a: Int) + (b: Int);

	@:op(A + B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function addInt(a: Time, b: Int): Time return (a: Int) + b;

	@:op(A + B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function addToInt(a: Int, b: Time): Time return a + (b: Int);

	@:op(A - B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function sub(a: Time, b: Time): Time return (a: Int) - (b: Int);

	@:op(A - B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function subInt(a: Time, b: Int): Time return (a: Int) - b;

	@:op(A - B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function subToInt(a: Int, b: Time): Time return a - (b: Int);

	@:op(A * B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function multiply1(a: Time, b: Int): Time return (a: Int) * b;

	@:op(A * B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function multiply2(a: Int, b: Time): Time return a * (b: Int);

	@:op(A * B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function divide(a: Time, b: Int): Time return ((a: Int) / b).int();

	@:op(A > B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function sb(a: Time, b: Time): Bool return (a: Int) > (b: Int);

	@:op(A > B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function sbInt(a: Time, b: Int): Bool return (a: Int) > b;

	@:op(A > B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function sbToInt(a: Int, b: Time): Bool return a > (b: Int);

	@:op(A < B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function sm(a: Time, b: Time): Bool return (a: Int) < (b: Int);

	@:op(A < B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function smInt(a: Time, b: Int): Bool return (a: Int) < b;

	@:op(A < B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function smToInt(a: Int, b: Time): Bool return a < (b: Int);

	@:op(A >= B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function sbr(a: Time, b: Time): Bool return (a: Int) >= (b: Int);

	@:op(A >= B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function sbrInt(a: Time, b: Int): Bool return (a: Int) >= b;

	@:op(A >= B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function sbrToInt(a: Int, b: Time): Bool return a >= (b: Int);

	@:op(A <= B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function smr(a: Time, b: Time): Bool return (a: Int) <= (b: Int);

	@:op(A <= B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function smrInt(a: Time, b: Int): Bool return (a: Int) <= b;

	@:op(A <= B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function smrToInt(a: Int, b: Time): Bool return a <= (b: Int);

	@:op(A == B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function sr(a: Time, b: Time): Bool return (a: Int) == (b: Int);

	@:op(A == B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function srInt(a: Time, b: Int): Bool return (a: Int) == b;

	@:op(A == B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function srToInt(a: Int, b: Time): Bool return a == (b: Int);

	@:op(A != B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function snr(a: Time, b: Time): Bool return (a: Int) != (b: Int);

	@:op(A != B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function snrInt(a: Time, b: Int): Bool return (a: Int) != b;

	@:op(A != B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function snrToInt(a: Int, b: Time): Bool return a != (b: Int);

	private function get_minimalPoint(): Int {
		return MathTools.cabs(
			if (ms != 0) {
				if (ms % 10 != 0) 1;
				else if (ms % 100 != 0) 10;
				else 100;
			}
			else if (seconds != 0) fromSeconds(1);
			else if (minutes != 0) fromMinutes(1);
			else if (hours != 0) fromHours(1);
			else fromDays(1)
		);
	}

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromDate(d: Date): Time return create(0, d.getHours(), d.getMinutes(), d.getSeconds());

}