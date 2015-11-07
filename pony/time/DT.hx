/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.time;

import Math.*;

using Std;

/**
 * DT
 * @author AxGord <axgord@gmail.com>
 */
abstract DT(Null<Float>) from Float to Float {
	
	public var ms(get, never):Float;
	public var sec(get, never):Null<Float>;
	public var min(get, never):Float;
	public var hour(get, never):Float;
	public var day(get, never):Float;

	public var _ms(get, never):Float;
	public var _sec(get, never):Float;
	public var _min(get, never):Float;
	public var _hour(get, never):Float;
	public var _day(get, never):Float;
	
	public var ms_sec(get, never):Float;
	public var ms_sec_(get, never):Float;
	public var ms_min(get, never):Float;
	public var ms_min_(get, never):Float;
	public var ms_hour(get, never):Float;
	public var ms_hour_(get, never):Float;
	public var ms_day(get, never):Float;
	public var ms_day_(get, never):Float;
	public var ms_(get, never):Int;
	
	public var sec_min(get, never):Float;
	public var sec_min_(get, never):Float;
	public var sec_hour(get, never):Float;
	public var sec_hour_(get, never):Float;
	public var sec_day(get, never):Float;
	public var sec_day_(get, never):Float;
	public var sec_(get, never):Int;
	
	public var min_hour(get, never):Float;
	public var min_hour_(get, never):Float;
	public var min_day(get, never):Float;
	public var min_day_(get, never):Float;
	public var min_(get, never):Int;
	
	public var hour_day(get, never):Float;
	public var hour_day_(get, never):Float;
	public var hour_(get, never):Int;
	
	public var day_(get, never):Int;
	
	@:extern inline public function new(v:Float) this = v;
	
	@:from @:extern inline public static function fromTime(v:Time):DT return new DT(v/1000);
	@:to @:extern inline public function toTime():Time return this * 1000;
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
	
	@:extern inline private function get_ms   ():Float return this / 1000;
	@:extern inline private function get_sec  ():Null<Float> return this;
	@:extern inline private function get_min  ():Float return sec * 60;
	@:extern inline private function get_hour ():Float return min * 60;
	@:extern inline private function get_day  ():Float return hour * 24;
	
	@:extern inline private function get__ms  ():Float return ms % 1;
	@:extern inline private function get__sec ():Float return sec % 1;
	@:extern inline private function get__min ():Float return min % 1;
	@:extern inline private function get__hour():Float return hour % 1;
	@:extern inline private function get__day ():Float return day % 1;
	
	@:extern inline private function get_ms_  ():Int return ms.int();
	@:extern inline private function get_sec_ ():Int return sec.int();
	@:extern inline private function get_min_ ():Int return min.int();
	@:extern inline private function get_hour_():Int return hour.int();
	@:extern inline private function get_day_ ():Int return day.int();
	
	@:extern inline private function get_ms_sec_  ():Float return ms_ / 1000;
	@:extern inline private function get_ms_sec   ():Float return ms_sec_ - sec_;
	@:extern inline private function get_ms_min_  ():Float return ms_ / 1000 / 60;
	@:extern inline private function get_ms_min   ():Float return ms_min_ - min_;
	@:extern inline private function get_ms_hour_ ():Float return ms_ / 1000 / 60 / 60;
	@:extern inline private function get_ms_hour  ():Float return ms_hour_ - hour_;
	@:extern inline private function get_ms_day_  ():Float return ms_ / 1000 / 60 / 60 / 24;
	@:extern inline private function get_ms_day   ():Float return ms_day_ - day_;
	
	@:extern inline private function get_sec_min_ ():Float return sec_ / 60;
	@:extern inline private function get_sec_min  ():Float return sec_min_ - min_;
	@:extern inline private function get_sec_hour_():Float return hour_ / 60 / 60;
	@:extern inline private function get_sec_hour ():Float return sec_hour_ - min_;
	@:extern inline private function get_sec_day_ ():Float return hour_ / 60 / 60 / 24;
	@:extern inline private function get_sec_day  ():Float return sec_day_ - min_;
	
	@:extern inline private function get_min_hour_():Float return min_ / 60;
	@:extern inline private function get_min_hour ():Float return min_hour_ - hour_;
	@:extern inline private function get_min_day_ ():Float return min_ / 60 / 24;
	@:extern inline private function get_min_day  ():Float return min_hour_ - hour_;
	
	@:extern inline private function get_hour_day_():Float return hour_ / 24;
	@:extern inline private function get_hour_day ():Float return hour_day_ - day_;
	
	@:op(A + B) @:extern inline static private function add(a:DT, b:DT):DT return (a:Float) + (b:Float);
	@:op(A + B) @:extern inline static private function addInt(a:DT, b:Int):DT return (a:Float) + b;
	@:op(A + B) @:extern inline static private function addToInt(a:Int, b:DT):DT return a + (b:Float);
	@:op(A + B) @:extern inline static private function addFloat(a:DT, b:Float):DT return (a:Float) + b;
	@:op(A + B) @:extern inline static private function addToFloat(a:Float, b:DT):DT return a + (b:Float);
	@:op(A + B) @:extern inline static private function addTime(a:DT, b:Time):DT return a + (b:DT);
	@:op(A + B) @:extern inline static private function addToTime(a:Time, b:DT):DT return (a:DT) + b;
	
	@:op(A - B) @:extern inline static private function sub(a:DT, b:DT):DT return (a:Float) - (b:Float);
	@:op(A - B) @:extern inline static private function subInt(a:DT, b:Int):DT return (a:Float) - b;
	@:op(A - B) @:extern inline static private function subToInt(a:Int, b:DT):DT return a - (b:Float);
	@:op(A - B) @:extern inline static private function subFloat(a:DT, b:Float):DT return (a:Float) - b;
	@:op(A - B) @:extern inline static private function subToFloat(a:Float, b:DT):DT return a - (b:Float);
	@:op(A - B) @:extern inline static private function subTime(a:DT, b:Time):DT return a - (b:DT);
	@:op(A - B) @:extern inline static private function subToTime(a:Time, b:DT):Time return (a:DT) - b;
	
	@:op(A * B) @:extern inline static private function multiplyFloat1(a:DT, b:Float):DT return (a:Float) * b;
	@:op(A * B) @:extern inline static private function multiplyFloat2(a:Float, b:DT):DT return a * (b:Float);
	@:op(A * B) @:extern inline static private function multiplyInt1(a:DT, b:Int):DT return (a:Float) * b;
	@:op(A * B) @:extern inline static private function multiplyInt2(a:Int, b:DT):DT return a * (b:Float);
	
	@:op(A / B) @:extern inline static private function divide(a:DT, b:Float):DT return ((a:Float) / b).int();
	@:op(A / B) @:extern inline static private function divideInt(a:DT, b:Int):DT return ((a:Float) / b).int();
	
	@:op(A > B) @:extern inline static private function sb(a:DT, b:DT):Bool return (a:Float) > (b:Float);
	@:op(A > B) @:extern inline static private function sbInt(a:DT, b:Int):Bool return (a:Float) > b;
	@:op(A > B) @:extern inline static private function sbToInt(a:Int, b:DT):Bool return a > (b:Float);
	@:op(A > B) @:extern inline static private function sbFloat(a:DT, b:Float):Bool return (a:Float) > b;
	@:op(A > B) @:extern inline static private function sbToFloat(a:Float, b:DT):Bool return a > (b:Float);
	@:op(A > B) @:extern inline static private function sbTime(a:DT, b:Time):Bool return a > (b:DT);
	@:op(A > B) @:extern inline static private function sbToTime(a:Time, b:DT):Bool return (a:DT) > b;
	
	@:op(A < B) @:extern inline static private function sm(a:DT, b:DT):Bool return (a:Float) < (b:Float);
	@:op(A < B) @:extern inline static private function smInt(a:DT, b:Int):Bool return (a:Float) < b;
	@:op(A < B) @:extern inline static private function smToInt(a:Int, b:DT):Bool return a < (b:Float);
	@:op(A < B) @:extern inline static private function smFloat(a:DT, b:Float):Bool return (a:Float) < b;
	@:op(A < B) @:extern inline static private function smToFloat(a:Float, b:DT):Bool return a < (b:Float);
	@:op(A < B) @:extern inline static private function smTime(a:DT, b:Time):Bool return a < (b:DT);
	@:op(A < B) @:extern inline static private function smToTime(a:Time, b:DT):Bool return (a:DT) < b;
	
	@:op(A >= B) @:extern inline static private function sbr(a:DT, b:DT):Bool return (a:Float) >= (b:Float);
	@:op(A >= B) @:extern inline static private function sbrInt(a:DT, b:Int):Bool return (a:Float) >= b;
	@:op(A >= B) @:extern inline static private function sbrToInt(a:Int, b:DT):Bool return a >= (b:Float);
	@:op(A >= B) @:extern inline static private function sbrFloat(a:DT, b:Float):Bool return (a:Float) >= b;
	@:op(A >= B) @:extern inline static private function sbrToFloat(a:Float, b:DT):Bool return a >= (b:Float);
	@:op(A >= B) @:extern inline static private function sbrTime(a:DT, b:Time):Bool return a >= (b:DT);
	@:op(A >= B) @:extern inline static private function sbrToTime(a:Time, b:DT):Bool return (a:DT) >= b;
	
	@:op(A <= B) @:extern inline static private function smr(a:DT, b:DT):Bool return (a:Float) <= (b:Float);
	@:op(A <= B) @:extern inline static private function smrInt(a:DT, b:Int):Bool return (a:Float) <= b;
	@:op(A <= B) @:extern inline static private function smrToInt(a:Int, b:DT):Bool return a <= (b:Float);
	@:op(A <= B) @:extern inline static private function smrFloat(a:DT, b:Float):Bool return (a:Float) <= b;
	@:op(A <= B) @:extern inline static private function smrToFloat(a:Float, b:DT):Bool return a <= (b:Float);
	@:op(A <= B) @:extern inline static private function smrTime(a:DT, b:Time):Bool return a <= (b:DT);
	@:op(A <= B) @:extern inline static private function smrToTime(a:Time, b:DT):Bool return (a:DT) <= b;
	
	@:op(A == B) @:extern inline static private function srNull(a:DT, b:Null<Float>):Bool return a.sec == null;
	
	@:op(A == B) @:extern inline static private function sr(a:DT, b:DT):Bool return (a:Float) == (b:Float);
	@:op(A == B) @:extern inline static private function srInt(a:DT, b:Int):Bool return (a:Float) == b;
	@:op(A == B) @:extern inline static private function srToInt(a:Int, b:DT):Bool return a == (b:Float);
	@:op(A == B) @:extern inline static private function srFloat(a:DT, b:Float):Bool return (a:Float) == b;
	@:op(A == B) @:extern inline static private function srToFloat(a:Float, b:DT):Bool return a == (b:Float);
	@:op(A == B) @:extern inline static private function srTime(a:DT, b:Time):Bool return a == (b:DT);
	@:op(A == B) @:extern inline static private function srToTime(a:Time, b:DT):Bool return (a:DT) == b;
	
	@:op(A != B) @:extern inline static private function srnNull(a:DT, b:Null<Float>):Bool return a.sec != null;
	
	@:op(A != B) @:extern inline static private function snr(a:DT, b:DT):Bool return (a:Float) != (b:Float);
	@:op(A != B) @:extern inline static private function snrInt(a:DT, b:Int):Bool return (a:Float) != b;
	@:op(A != B) @:extern inline static private function snrToInt(a:Int, b:DT):Bool return a != (b:Float);
	@:op(A != B) @:extern inline static private function snrFloat(a:DT, b:Float):Bool return (a:Float) != b;
	@:op(A != B) @:extern inline static private function snrToFloat(a:Float, b:DT):Bool return a != (b:Float);
	@:op(A != B) @:extern inline static private function snrTime(a:DT, b:Time):Bool return a != (b:DT);
	@:op(A != B) @:extern inline static private function snrToTime(a:Time, b:DT):Bool return (a:DT) != b;
}