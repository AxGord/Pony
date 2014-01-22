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

import pony.events.*;
import pony.events.Listener1.Listener1;
import pony.magic.Declarator;

/**
 * DeltaTime Timer
 * Can work as Clock
 * @author AxGord
 */
class DTimer implements ITimer<DTimer> implements Declarator {
	
	public var currentTime:Time;
	
	public var update:Signal1<DTimer, Time> = Signal.create(this);
	public var progress:Signal1<DTimer, Float> = Signal.create(this);
	public var complite:Signal1<DTimer, DT> = Signal.create(this);
	
	private var sumdt:DT = 0;

	@:arg private var updateSignal:Signal1<Void, DT>;
	@:arg public var time:TimeInterval = null;
	@:arg public var repeatCount:Int = 0;
	
	public function new() {
		progress.takeListeners.add(takeProgress).lostListeners.add(lostProgress);
		reset();
	}
	
	private function takeProgress():Void update.add(_progress);
	private function lostProgress():Void update.remove(_progress);
	
	public function reset():DTimer {
		if (time != null)
			currentTime = time.back ? time.max : time.min;
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
		if (dt >= 0.001) {
			var t:Time = sumdt;
			sumdt -= t;
			if (time != null) {
				if (time.back) {
					currentTime -= t;
					while (currentTime <= time.max) if (loop()) break;
					else dispatchUpdate();
				} else {
					currentTime += t;
					while (currentTime >= time.max) if (loop()) break;
					else dispatchUpdate();
				}
			} else {
				currentTime += t;
				dispatchUpdate();
			}
		}
	}
	
	private function loop():Bool {
		var result:Bool = false;
		var d:DT = Math.abs((currentTime:DT) - (time.max:DT)) + sumdt;
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
		dispatchUpdate();
		complite.dispatch(d);
		return result;
	}
	
	public inline function dispatchUpdate():DTimer return update.dispatch(currentTime);
	
	public function destroy():Void {
		stop();
		progress.destroy();
		update.destroy();
		complite.destroy();
		progress = null;
		update = null;
		complite = null;
		time = null;
	}
	
	private function _progress():Void progress.dispatch(time.percent(currentTime));
	
	static public inline function createTimer     (time:TimeInterval, repeat:Int = 0):DTimer return new DTimer(DeltaTime.update, time, repeat);
	static public inline function createFixedTimer(time:TimeInterval, repeat:Int = 0):DTimer return new DTimer(DeltaTime.fixedUpdate, time, repeat);
	
	static public inline function delay           (time:Time, f:Listener1<DTimer, DT>, ?dt:DT):DTimer {
		var t = DTimer.createTimer(time).complite.once(f);
		return t.complite.once(t.destroy).start(dt);
	}
	static public inline function fixedDelay      (time:Time, f:Listener1<DTimer, DT>, ?dt:DT):DTimer {
		var t = DTimer.createFixedTimer(time).complite.once(f);
		return t.complite.once(t.destroy).start(dt);
	}
	static public inline function repeat          (time:Time, f:Listener1<DTimer, DT>, ?dt:DT):DTimer return DTimer.createTimer(time, -1).complite.add(f).start(dt);
	static public inline function fixedRepeat     (time:Time, f:Listener1<DTimer, DT>, ?dt:DT):DTimer return DTimer.createFixedTimer(time, -1).complite.add(f).start(dt);
	
}