/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

@:enum abstract TweenType(Int) {
	var Linear = 0;
	var Square = 1;
	var BackSquare = 2;
	var Bezier = 3;
}

/**
 * Tween
 * @author AxGord <axgord@gmail.com>
 */
class Tween implements HasSignal implements Declarator {
	
	@:auto public var onUpdate:Signal1<Float>;
	@:auto public var onProgress:Signal1<Float>;
	@:auto public var onComplete:Signal1<Float>;
	@:auto public var onSkip:Signal1<Int>;
	
	@:arg public var range:Interval<Float> = 0...1;
	
	/**
	 * Next start will be backward
	 */
	private var invert:Bool;
	
	private var updateSignal:Signal1<DT>;
	private var progress:Float = 0;
	private var sr:Float;
	private var playing:Bool = false;
	private var type:TweenType;
	private var skipTime:Float;
	
	public function new(
		type:TweenType = TweenType.Linear,
		time:Time = 1000,
		invert:Bool = false,
		loop:Bool = false,
		pingpong:Bool = false,
		fixedTime:Bool = false,
		?skipTime:Time
	) {
		this.type = type;
		sr = 1000 / time;
		this.invert = invert;
		updateSignal = fixedTime ? DeltaTime.fixedUpdate : DeltaTime.update;
		if (pingpong) {
			if (skipTime == null) skipTime = time / 500;
			onComplete << invertInvert;
		} else {
			if (skipTime == null) skipTime = time / 1000;
		}
		this.skipTime = skipTime;
		onComplete << endPlay;
		if (loop) onComplete << play;
		onProgress << progressHandler;
	}
	
	private function progressHandler(v:Float):Void {
		v = switch type {
			case Linear: v;
			case Square: v * v;
			case BackSquare: 1 - Math.pow(1 - v, 2);
			case Bezier: v * v * (3 - 2 * v);
		};
		eUpdate.dispatch(MathTools.percentCalc(v, range.min, range.max));
	}
	
	private function invertInvert():Void invert = !invert;
	private function endPlay():Void playing = false;
	
	public function playForward(?dt:DT):Void {
		if (playing) pause();
		invert = false;
		playing = true;
		updateSignal << forward;
		if (dt != null) forward(dt);
	}
	
	public function playBack(?dt:DT):Void {
		if (playing) pause();
		invert = true;
		playing = true;
		updateSignal << backward;
		if (dt != null) backward(dt);
	}
	
	public function play(?dt:DT):Void {
		if (updateSignal == null) return;
		if (playing) return;
		playing = true;
		if (dt > skipTime) {
			var c = Std.int(dt.sec / skipTime);
			dt -= skipTime * c;
			eSkip.dispatch(c);
		}
		if (invert) {
			if (progress == 0) progress = 1;
		} else {
			if (progress == 1) progress = 0;
		}
		if (!invert) {
			updateSignal << forward;
			if (dt != null) forward(dt);
		} else {
			updateSignal << backward;
			if (dt != null) backward(dt);
		}
	}
	
	private function forward(dt:Float):Void {
		if (updateSignal == null) {
			DeltaTime.fixedUpdate >> forward;
			DeltaTime.update >> forward;
			return;//todo: fix bug (check this)
		}
		if (!playing) {
			//trace('forward');
			updateSignal >> forward;
			return;//todo: fix bug (check this)
		}
		progress += dt * sr;
		if (progress >= 1) {
			updateSignal >> forward;
			var d = MathTools.range(progress, 1) / sr;
			progress = 1;
			update();
			eComplete.dispatch(d);
		} else {
			update();
		}
	}
	
	private function backward(dt:Float):Void {
		if (updateSignal == null) {
			DeltaTime.fixedUpdate >> backward;
			DeltaTime.update >> backward;
			return;//todo: fix bug (check this)
		}
		if (!playing) {
			//trace('backward');
			updateSignal >> backward;
			return;//todo: fix bug (check this)
		}
		progress -= dt * sr;
		if (progress <= 0) {
			updateSignal >> backward;
			var d = MathTools.range(progress, 0) / sr;
			progress = 0;
			update();
			eComplete.dispatch(d);
		} else {
			update();
		}
	}
	
	inline public function update():Void eProgress.dispatch(progress);
	
	public function pause():Void {
		if (updateSignal == null) return;
		updateSignal.remove(invert ? backward : forward);
		playing = false;
	}
	
	public function stopOnBegin():Void {
		if (updateSignal == null) return;
		pause();
		invert = false;
		progress = 0;
		update();
	}
	
	public function stopOnEnd():Void {
		if (updateSignal == null) return;
		pause();
		invert = true;
		progress = 1;
		update();
	}
	
	public function destroy():Void {
		pause();
		this.destroySignals();
		updateSignal = null;
		range = null;
	}
	
}