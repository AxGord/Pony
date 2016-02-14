/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.math.MathTools;

/**
 * Tween
 * @author AxGord <axgord@gmail.com>
 */
class Tween implements HasSignal implements Declarator {
	
	@:auto public var onUpdate:Signal1<Float>;
	@:auto public var onComplete:Signal1<Float>;
	
	@:arg private var range:Interval<Float> = 0...1;
	
	/**
	 * Next start will be backward
	 */
	private var invert:Bool;
	
	private var updateSignal:Signal1<DT>;
	private var value:Float;
	private var sr:Float;
	private var playing:Bool = false;
	
	public function new(time:Time = 1000, invert:Bool = false, loop:Bool = false, pingpong:Bool = false, fixedTime:Bool = false) {
		var speed = 1000 / time;
		sr = speed * range.range;
		this.invert = invert;
		updateSignal = fixedTime ? DeltaTime.fixedUpdate : DeltaTime.update;
		value = invert ? range.max : range.min;
		if (pingpong) onComplete << invertInvert;
		onComplete << endPlay;
		if (loop) onComplete << play;
	}
	
	private function invertInvert():Void invert = !invert;
	private function endPlay():Void playing = false;
	
	public function play(?dt:DT):Void {
		if (playing) return;
		playing = true;
		if (!invert) {
			updateSignal << forward;
			if (dt != null) forward(dt);
		} else {
			updateSignal << backward;
			if (dt != null) backward(dt);
		}
	}
	
	private function forward(dt:Float):Void {
		value += dt * sr;
		if (value >= range.max) {
			updateSignal >> forward;
			var d = MathTools.range(value, range.max) / sr;
			value = range.max;
			update();
			eComplete.dispatch(d);
		} else {
			update();
		}
	}
	
	private function backward(dt:Float):Void {
		value -= dt * sr;
		if (value <= range.min) {
			updateSignal >> backward;
			var d = MathTools.range(value, range.min) / sr;
			value = range.min;
			update();
			eComplete.dispatch(d);
		} else {
			update();
		}
	}
	
	@:extern inline private function update():Void eUpdate.dispatch(value);
	
	public function stopOnBegin():Void {
		updateSignal.remove(invert ? backward : forward);
		invert = false;
		value = range.min;
		update();
		playing = false;
	}
	
	public function stopOnEnd():Void {
		updateSignal.remove(invert ? backward : forward);
		invert = true;
		value = range.max;
		update();
		playing = false;
	}
	
}