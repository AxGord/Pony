/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony;
import pony.events.Signal;
using pony.Tools;
/**
 * Smooth
 * @author AxGord <axgord@gmail.com>
 */
class Smooth {

	public var value(default, null):Null<Float> = null;
	public var time:Float;
	public var update(default, null):Signal;
	private var vals:Array<Float>;
	private var dtsum:Float;
	private var last:Null<Float>;
	
	public function new(time:Float = 0.5) {
		this.time = time;
		dtsum = 0;
		vals = [];
		update = new Signal();
		DeltaTime.update.add(tick);
	}
	
	public function set(v:Float):Void {
		if (value == null) {
			value = v;
			update.dispatch(value);
		}
		vals.push(v);
		last = v;
	}
	
	private function tick(dt:Float):Void {
		dtsum += dt;
		if (dtsum < time) return;
		dtsum %= time;
		if (vals.length == 0) {
			if (last != null) {
				value = last;
				update.dispatch(value);
				last = null;
			}
			return;
		}
		value = vals.arithmeticMean();
		vals = [];
		update.dispatch(value);
	}
	
	public function reset():Void
	{
		vals = [];
		value = 0;
		update.dispatch(value);
	}
	
	
}