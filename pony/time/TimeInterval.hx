/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pony.math.MathTools;

using Reflect;

typedef TimeInterval_ = { min:Time, max:Time };

/**
 * TimeInterval
 * @author AxGord <axgord@gmail.com>
 */
abstract TimeInterval(TimeInterval_) {
	
	public var min(get, never):Time;
	public var max(get, never):Time;
	public var mid(get, never):Time;
	public var back(get, never):Bool;
	public var length(get, never):Time;
	public var minimalPoint(get, never):Time;

	inline public function new(o:TimeInterval_) this = o;
	
	inline private function get_min():Time return this.min;
	inline private function get_max():Time return this.max;
	
	@:from inline private static function fromInterator(it:IntIterator):TimeInterval
		return create(it.field('min'), it.field('max'));
	
	@:to inline public function toString():String return (min:String) + ' ... ' + (max:String);
	
	@:from private static function fromString(time:String):TimeInterval {
		var a = time.split('...');
		if (a.length > 1)
			return new TimeInterval( { min: a[0], max: a[1] } );
		else
			return fromTime(a[0]);
	}
	
	@:from inline private static function fromTime(time:Time):TimeInterval return new TimeInterval( { min: 0, max: time } );
	
	inline public function check(t:Time):Bool return t >= min && t <= max;
		
	inline private function get_back():Bool return min > max;
	inline private function get_length():Time return max - min;
	
	inline public function percent(time:Time):Float return MathTools.percentCalcd(time, min, max);
	
	inline private function get_minimalPoint():Int return MathTools.cmin(min.minimalPoint, max.minimalPoint);
	
	inline private function get_mid():Time return Math.abs(max - min) / 2;
	
	inline public static function create(min:Time, max:Time):TimeInterval return new TimeInterval( { min:min, max:max });
}