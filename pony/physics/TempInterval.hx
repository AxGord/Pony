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
package pony.physics;

import pony.Interval;
import pony.Pair;
import pony.physics.Temp;

/**
 * TempInterval
 * @author AxGord <axgord@gmail.com>
 */
abstract TempInterval(Interval<Temp>) from Interval<Temp> to Interval<Temp> {

	public var min(get, never):Temp;
	public var max(get, never):Temp;
	public var mid(get, never):Temp;
	
	inline private function get_min():Temp return this.min;
	inline private function get_max():Temp return this.max;
	inline private function get_mid():Temp return this.mid;
	
	inline public function new(v:Interval<Temp>) this = v;
	
	@:from inline private static function fromStringInterval(it:Interval<String>):TempInterval {
		return new Interval<Temp>(new Pair<Temp, Temp>(it.min == null ? Math.NEGATIVE_INFINITY : it.min, it.max));
	}
	
	@:to inline private function toStringInterval():Interval<String> return new Interval<String>(new Pair<String,String>(min, max));

	@:to inline private function toString():String return toStringInterval();
	
	@:from inline static public function fromString(s:String):TempInterval return Interval.fromString(s);
	
}