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

import pony.events.*;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.math.MathTools;

/**
 * Timer with signals
 * @author AxGord
 */
class Timer implements ITimer<Timer> implements Declarator implements HasSignal {
	
	#if (!neko && !dox && !cpp)
	private var t:haxe.Timer;
	#elseif munit
	private var t:massive.munit.util.Timer;
	#end
	
	public var currentTime:Time;
	
	public var started(get, never):Bool;
	
	@:auto public var update:Signal1<Time>;
	@:auto public var progress:Signal1<Float>;
	@:auto public var complete:Signal1<DT>;
	
	public var frequency:Time = 1000;
	private var _frequency:Time;
	
	@:arg public var time:TimeInterval = null;
	@:arg public var repeatCount:Int = 0;
	
	public function new() {
		eProgress.onTake.add(takeProgress);
		eProgress.onLost.add(lostProgress);
		eUpdate.onTake.add(lUpdate);
		eProgress.onLost.add(lUpdate);
		reset();
	}
	#if !dox
	inline private function get_started():Bool return t != null;
	#else
	inline private function get_started():Bool return false;
	#end
	private function takeProgress():Void update.add(_progress);
	private function lostProgress():Void update.remove(_progress);
	
	private function lUpdate():Void if (time != null) start();
	
	public function reset():Timer {
		if (time != null) {
			currentTime = time.back ? time.max : time.min;
			_frequency = frequency;
		} else {
			currentTime = 0;
			_frequency = MathTools.cmin(frequency, time.minimalPoint);
		}
		if (started) start();
		return this;
	}
	
	inline public function restart(?dt:DT):Void {
		stop();
		reset();
		start(dt);
	}
	
	public function start(?dt:DT):Timer {
		stop();
		var delay:Int = !eUpdate.empty || time == null ? _frequency : MathTools.cabs(time.max - currentTime);
		#if (!neko && !dox && !cpp)
		t = new haxe.Timer(delay);
		t.run = !update.empty ? _update : _complite;
		#elseif munit
		t = new massive.munit.util.Timer(delay);
		t.run = !eUpdate.empty ? _update : _complite;
		#end
		return this;
	}
	
	private function _complite():Void {
		eComplete.dispatch(0);
		if (repeatCount == 0) stop();
		else if (repeatCount > 0) repeatCount--;
	}
	
	private function _update():Void {
		if (time.back) {
			currentTime -= _frequency;
		} else {
			currentTime += _frequency;
			if (currentTime >= time.max) while (currentTime >= time.max) {
				currentTime -= time.length;
				dispatchUpdate();
				eComplete.dispatch(0);
				if (repeatCount == 0) {
					stop();
					break;
				}
				else if (repeatCount > 0) repeatCount--;
			} else dispatchUpdate();
		}
	}
	
	public function stop():Timer {
		#if ((!neko && !dox && !cpp) || munit)
		if (t != null) {
			t.stop();
			t = null;
		}
		#end
		return this;
	}
	
	public inline function dispatchUpdate():Timer {
		eUpdate.dispatch(currentTime);
		return this;
	}
	
	public function destroy():Void {
		stop();
		eProgress.destroy();
		eUpdate.destroy();
		eComplete.destroy();
		eProgress = null;
		eUpdate = null;
		eComplete = null;
		time = null;
	}
	
	private function _progress():Void eProgress.dispatch(time.percent(currentTime));
	
	static public inline function delay (time:Time, f:Void->Void):Timer {
		var t = new Timer(time);
		t.complete.once(f);
		t.complete.once(t.destroy);
		return t.start();
	}
	static public inline function repeat(time:Time, f:Void->Void):Timer {
		var t = new Timer(time, -1);
		t.complete.add(f);
		return t.start();
	}
	
}