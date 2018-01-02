/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.time;

import pony.events.*;
import pony.magic.Declarator;
import pony.magic.HasSignal;

/**
 * DeltaTime Timer
 * Can work as Clock
 * @author AxGord
 */
class DTimer implements HasSignal implements ITimer<DTimer> implements Declarator {
	
	public var currentTime:Time;
	
	@:auto public var update:Signal1<Time>;
	@:auto public var progress:Signal1<Float>;
	@:auto public var complete:Signal1<DT>;
	
	private var sumdt:DT = 0;

	@:arg private var updateSignal:Signal1<DT>;
	@:arg public var time:TimeInterval = null;
	@:arg public var repeatCount:Int = 0;
	
	public function new() {
		eProgress.onTake.add(takeProgress);
		eProgress.onLost.add(lostProgress);
		reset();
	}
	
	private function takeProgress():Void update.add(_progress);
	private function lostProgress():Void update.remove(_progress);
	
	public function reset():DTimer {
		if (time != null)
			currentTime = time.min;
		else
			currentTime = 0;
		return this;
	}
	
	public inline function start(?dt:DT):DTimer {
		updateSignal.add(_update);
		if (dt != null) _update(dt);
		return this;
	}
	
	public inline function stop():DTimer {
		updateSignal.remove(_update);
		return this;
	}
	
	private function _update(dt:DT):Void {
		sumdt += dt;
		if (sumdt >= 0.001) {
			var t:Time = sumdt.toTime();
			sumdt -= DT.fromTime(t);
			if (time != null) {
				if (time.back) {
					currentTime -= t;
					while (currentTime <= time.max) if (loop()) break;
				} else {
					currentTime += t;
					while (currentTime >= time.max) if (loop()) break;
				}
			} else {
				currentTime += t;
			}
			dispatchUpdate();
		}
	}
	
	private function loop():Bool {
		if (eComplete == null) return true;
		var result:Bool = false;
		var d:DT = Math.abs(currentTime - time.max)/1000 + sumdt;
		if (repeatCount > 0) {
			currentTime -= time.length;
			repeatCount--;
		} else if (repeatCount == -1) {
			currentTime -= time.length;
		} else {
			currentTime = time.max;
			stop();
			result = true;
		}
		eComplete.dispatch(d);
		return result;
	}
	
	public inline function dispatchUpdate():DTimer {
		if (update != null) eUpdate.dispatch(currentTime);
		return this;
	}
	
	public function destroy():Void {
		if (update == null) return;
		eProgress.onTake.remove(takeProgress);
		eProgress.onLost.remove(lostProgress);
		destroySignals();
		time = null;
	}
	
	private function _progress():Void eProgress.dispatch(time.percent(currentTime));
	
	public inline function toString():String return currentTime;
	
	static public inline function createTimer     (time:TimeInterval, repeat:Int = 0):DTimer return new DTimer(DeltaTime.update, time, repeat);
	static public inline function createFixedTimer(time:TimeInterval, repeat:Int = 0):DTimer return new DTimer(DeltaTime.fixedUpdate, time, repeat);
	
	static public inline function delay(time:Time, f:Listener1<DT>, ?dt:DT):DTimer {
		var t = DTimer.createTimer(time);
		t.complete.once(f);
		t.complete.once(t.destroy);
		t.start(dt);
		return t;
	}
	static public inline function fixedDelay(time:Time, f:Listener1<DT>, ?dt:DT):DTimer {
		var t = DTimer.createFixedTimer(time);
		t.complete.once(f);
		t.complete.once(t.destroy);
		t.start(dt);
		return t;
	}
	static public inline function repeat(time:Time, f:Listener1 < DT >, ?dt:DT):DTimer {
		var t = DTimer.createTimer(time, -1);
		t.complete.add(f);
		t.start(dt);
		return t;
	}
	static public inline function fixedRepeat(time:Time, f:Listener1 < DT > , ?dt:DT):DTimer {
		var t = DTimer.createFixedTimer(time, -1);
		t.complete.add(f);
		t.start(dt);
		return t;
	}
	
	static public inline function clock(time:Time):DTimer {
		var t = createTimer(null);
		t.currentTime = time;
		t.start();
		return t;
	}
	
	static public inline function fixedClock(time:Time):DTimer {
		var t = createFixedTimer(null);
		t.currentTime = time;
		t.start();
		return t;
	}
}