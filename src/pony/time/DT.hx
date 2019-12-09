package pony.time;

import Math.*;

using Std;

/**
 * DT
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) abstract DT(Float) from Float to Float {

	public var ms(get, never): Float;
	public var sec(get, never): Float;
	public var min(get, never): Float;
	public var hour(get, never): Float;
	public var day(get, never): Float;

	public var _ms(get, never): Float;
	public var _sec(get, never): Float;
	public var _min(get, never): Float;
	public var _hour(get, never): Float;
	public var _day(get, never): Float;

	public var ms_sec(get, never): Float;
	public var ms_sec_(get, never): Float;
	public var ms_min(get, never): Float;
	public var ms_min_(get, never): Float;
	public var ms_hour(get, never): Float;
	public var ms_hour_(get, never): Float;
	public var ms_day(get, never): Float;
	public var ms_day_(get, never): Float;
	public var ms_(get, never): Int;

	public var sec_min(get, never): Float;
	public var sec_min_(get, never): Float;
	public var sec_hour(get, never): Float;
	public var sec_hour_(get, never): Float;
	public var sec_day(get, never): Float;
	public var sec_day_(get, never): Float;
	public var sec_(get, never): Int;

	public var min_hour(get, never): Float;
	public var min_hour_(get, never): Float;
	public var min_day(get, never): Float;
	public var min_day_(get, never): Float;
	public var min_(get, never): Int;

	public var hour_day(get, never): Float;
	public var hour_day_(get, never): Float;
	public var hour_(get, never): Int;

	public var day_(get, never): Int;

	@:extern public inline function new(v: Float) this = v;
	@:from @:extern public static inline function fromTime(v: Time): DT return new DT(v / 1000);
	@:to @:extern public inline function toTime(): Time return this * 1000;

	/*
	@:to public function toString():String {
		var d:Float = this % 1;
		var t:Time = toTime();
		if (d == 0)
			return t;
		else if (t.ms > 0)
			return t.toString() + '.' + Std.string(d).substr(1);
		else
			return t.toString() + '..' + Std.string(d).substr(1);
	}*/

	@:extern private inline function get_ms   (): Float return this / 1000;
	@:extern private inline function get_sec  (): Null<Float> return this;
	@:extern private inline function get_min  (): Float return sec * 60;
	@:extern private inline function get_hour (): Float return min * 60;
	@:extern private inline function get_day  (): Float return hour * 24;

	@:extern private inline function get__ms  (): Float return ms % 1;
	@:extern private inline function get__sec (): Float return sec % 1;
	@:extern private inline function get__min (): Float return min % 1;
	@:extern private inline function get__hour(): Float return hour % 1;
	@:extern private inline function get__day (): Float return day % 1;

	@:extern private inline function get_ms_  (): Int return ms.int();
	@:extern private inline function get_sec_ (): Int return sec.int();
	@:extern private inline function get_min_ (): Int return min.int();
	@:extern private inline function get_hour_(): Int return hour.int();
	@:extern private inline function get_day_ (): Int return day.int();

	@:extern private inline function get_ms_sec_  (): Float return ms_ / 1000;
	@:extern private inline function get_ms_sec   (): Float return ms_sec_ - sec_;
	@:extern private inline function get_ms_min_  (): Float return ms_ / 1000 / 60;
	@:extern private inline function get_ms_min   (): Float return ms_min_ - min_;
	@:extern private inline function get_ms_hour_ (): Float return ms_ / 1000 / 60 / 60;
	@:extern private inline function get_ms_hour  (): Float return ms_hour_ - hour_;
	@:extern private inline function get_ms_day_  (): Float return ms_ / 1000 / 60 / 60 / 24;
	@:extern private inline function get_ms_day   (): Float return ms_day_ - day_;

	@:extern private inline function get_sec_min_ (): Float return sec_ / 60;
	@:extern private inline function get_sec_min  (): Float return sec_min_ - min_;
	@:extern private inline function get_sec_hour_(): Float return hour_ / 60 / 60;
	@:extern private inline function get_sec_hour (): Float return sec_hour_ - min_;
	@:extern private inline function get_sec_day_ (): Float return hour_ / 60 / 60 / 24;
	@:extern private inline function get_sec_day  (): Float return sec_day_ - min_;

	@:extern private inline function get_min_hour_(): Float return min_ / 60;
	@:extern private inline function get_min_hour (): Float return min_hour_ - hour_;
	@:extern private inline function get_min_day_ (): Float return min_ / 60 / 24;
	@:extern private inline function get_min_day  (): Float return min_hour_ - hour_;

	@:extern private inline function get_hour_day_(): Float return hour_ / 24;
	@:extern private inline function get_hour_day (): Float return hour_day_ - day_;

	@:op(A + B) @:extern private static inline function add(a: DT, b: DT): DT return (a: Float) + (b: Float);
	@:op(A + B) @:extern private static inline function addInt(a: DT, b: Int): DT return (a: Float) + b;
	@:op(A + B) @:extern private static inline function addToInt(a: Int, b: DT): DT return a + (b: Float);
	@:op(A + B) @:extern private static inline function addFloat(a: DT, b: Float): DT return (a: Float) + b;
	@:op(A + B) @:extern private static inline function addToFloat(a: Float, b: DT):DT return a + (b: Float);
	@:op(A + B) @:extern private static inline function addTime(a: DT, b: Time):DT return a + (b: DT);
	@:op(A + B) @:extern private static inline function addToTime(a: Time, b: DT):DT return (a: DT) + b;

	@:op(A - B) @:extern private static inline function sub(a: DT, b: DT): DT return (a: Float) - (b: Float);
	@:op(A - B) @:extern private static inline function subInt(a: DT, b: Int): DT return (a: Float) - b;
	@:op(A - B) @:extern private static inline function subToInt(a: Int, b: DT): DT return a - (b: Float);
	@:op(A - B) @:extern private static inline function subFloat(a: DT, b: Float): DT return (a: Float) - b;
	@:op(A - B) @:extern private static inline function subToFloat(a: Float, b: DT): DT return a - (b: Float);
	@:op(A - B) @:extern private static inline function subTime(a: DT, b: Time): DT return a - (b: DT);
	@:op(A - B) @:extern private static inline function subToTime(a: Time, b: DT): Time return (a: DT) - b;

	@:op(A * B) @:extern private static inline function multiplyFloat1(a: DT, b: Float): DT return (a: Float) * b;
	@:op(A * B) @:extern private static inline function multiplyFloat2(a: Float, b: DT): DT return a * (b: Float);
	@:op(A * B) @:extern private static inline function multiplyInt1(a: DT, b: Int): DT return (a: Float) * b;
	@:op(A * B) @:extern private static inline function multiplyInt2(a: Int, b: DT):DT return a * (b: Float);

	@:op(A / B) @:extern private static inline function divide(a: DT, b: Float): DT return ((a: Float) / b).int();
	@:op(A / B) @:extern private static inline function divideInt(a: DT, b: Int): DT return ((a: Float) / b).int();

	@:op(A > B) @:extern private static inline function sb(a: DT, b: DT): Bool return (a: Float) > (b: Float);
	@:op(A > B) @:extern private static inline function sbInt(a: DT, b: Int): Bool return (a: Float) > b;
	@:op(A > B) @:extern private static inline function sbToInt(a: Int, b: DT): Bool return a > (b: Float);
	@:op(A > B) @:extern private static inline function sbFloat(a: DT, b: Float): Bool return (a: Float) > b;
	@:op(A > B) @:extern private static inline function sbToFloat(a: Float, b: DT): Bool return a > (b: Float);
	@:op(A > B) @:extern private static inline function sbTime(a: DT, b: Time): Bool return a > (b: DT);
	@:op(A > B) @:extern private static inline function sbToTime(a: Time, b: DT):Bool return (a: DT) > b;

	@:op(A < B) @:extern private static inline function sm(a: DT, b: DT): Bool return (a: Float) < (b: Float);
	@:op(A < B) @:extern private static inline function smInt(a: DT, b: Int):Bool return (a: Float) < b;
	@:op(A < B) @:extern private static inline function smToInt(a: Int, b: DT):Bool return a < (b: Float);
	@:op(A < B) @:extern private static inline function smFloat(a: DT, b: Float): Bool return (a: Float) < b;
	@:op(A < B) @:extern private static inline function smToFloat(a: Float, b: DT):Bool return a < (b: Float);
	@:op(A < B) @:extern private static inline function smTime(a: DT, b: Time): Bool return a < (b: DT);
	@:op(A < B) @:extern private static inline function smToTime(a: Time, b: DT):Bool return (a: DT) < b;

	@:op(A >= B) @:extern private static inline function sbr(a: DT, b: DT):Bool return (a: Float) >= (b: Float);
	@:op(A >= B) @:extern private static inline function sbrInt(a: DT, b: Int):Bool return (a: Float) >= b;
	@:op(A >= B) @:extern private static inline function sbrToInt(a: Int, b: DT):Bool return a >= (b: Float);
	@:op(A >= B) @:extern private static inline function sbrFloat(a: DT, b: Float): Bool return (a: Float) >= b;
	@:op(A >= B) @:extern private static inline function sbrToFloat(a: Float, b: DT): Bool return a >= (b: Float);
	@:op(A >= B) @:extern private static inline function sbrTime(a: DT, b: Time): Bool return a >= (b: DT);
	@:op(A >= B) @:extern private static inline function sbrToTime(a: Time, b: DT): Bool return (a: DT) >= b;

	@:op(A <= B) @:extern private static inline function smr(a: DT, b: DT): Bool return (a: Float) <= (b: Float);
	@:op(A <= B) @:extern private static inline function smrInt(a: DT, b: Int): Bool return (a: Float) <= b;
	@:op(A <= B) @:extern private static inline function smrToInt(a: Int, b: DT): Bool return a <= (b: Float);
	@:op(A <= B) @:extern private static inline function smrFloat(a: DT, b: Float):Bool return (a: Float) <= b;
	@:op(A <= B) @:extern private static inline function smrToFloat(a: Float, b: DT): Bool return a <= (b: Float);
	@:op(A <= B) @:extern private static inline function smrTime(a: DT, b: Time): Bool return a <= (b: DT);
	@:op(A <= B) @:extern private static inline function smrToTime(a: Time, b: DT): Bool return (a: DT) <= b;

	@:op(A == B) @:extern private static inline function srNull(a: DT, b: Null<Float>): Bool return a.sec == null;

	@:op(A == B) @:extern private static inline function sr(a: DT, b: DT): Bool return (a: Float) == (b: Float);
	@:op(A == B) @:extern private static inline function srInt(a: DT, b: Int): Bool return (a: Float) == b;
	@:op(A == B) @:extern private static inline function srToInt(a: Int, b: DT): Bool return a == (b: Float);
	@:op(A == B) @:extern private static inline function srFloat(a: DT, b: Float): Bool return (a: Float) == b;
	@:op(A == B) @:extern private static inline function srToFloat(a: Float, b: DT): Bool return a == (b: Float);
	@:op(A == B) @:extern private static inline function srTime(a: DT, b: Time): Bool return a == (b: DT);
	@:op(A == B) @:extern private static inline function srToTime(a: Time, b: DT): Bool return (a: DT) == b;

	@:op(A != B) @:extern private static inline function srnNull(a: DT, b: Null<Float>): Bool return a.sec != null;

	@:op(A != B) @:extern private static inline function snr(a: DT, b: DT): Bool return (a: Float) != (b: Float);
	@:op(A != B) @:extern private static inline function snrInt(a: DT, b: Int): Bool return (a: Float) != b;
	@:op(A != B) @:extern private static inline function snrToInt(a: Int, b: DT): Bool return a != (b: Float);
	@:op(A != B) @:extern private static inline function snrFloat(a: DT, b: Float): Bool return (a: Float) != b;
	@:op(A != B) @:extern private static inline function snrToFloat(a: Float, b: DT): Bool return a != (b: Float);
	@:op(A != B) @:extern private static inline function snrTime(a: DT, b: Time): Bool return a != (b: DT);
	@:op(A != B) @:extern private static inline function snrToTime(a: Time, b: DT): Bool return (a: DT) != b;

}