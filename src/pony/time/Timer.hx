package pony.time;

import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.math.MathTools;

/**
 * Timer with signals
 * @author AxGord <axgord@gmail.com>
 */
class Timer implements ITimer<Timer> implements Declarator implements HasSignal {

	#if (!neko && !dox && !cpp)
	private var t: haxe.Timer;
	#elseif munit
	private var t: massive.munit.util.Timer;
	#end

	public var currentTime: Time;

	public var started(get, never): Bool;

	@:auto public var update: Signal1<Time>;
	@:auto public var progress: Signal1<Float>;
	@:auto public var complete: Signal1<DT>;

	public var frequency: Time = 1000;
	private var _frequency: Time;

	@:arg public var time: TimeInterval = null;
	public var repeatCount(default, set): Int = 0;

	public function new(repeatCount: Int = 0) {
		this.repeatCount = repeatCount;
		eProgress.onTake.add(takeProgress);
		eProgress.onLost.add(lostProgress);
		eUpdate.onTake.add(lUpdate);
		eProgress.onLost.add(lUpdate);
		reset();
	}

	public inline function set_repeatCount(value: Int): Int {
		repeatCount = value;
		return value;
	}

	#if !dox
	private inline function get_started(): Bool return t != null;
	#else
	private inline function get_started(): Bool return false;
	#end

	private function takeProgress(): Void update.add(_progress);
	private function lostProgress(): Void update.remove(_progress);

	private function lUpdate(): Void if (time != null) start();

	public function reset(): Timer {
		if (time != null) {
			currentTime = time.min;
			_frequency = frequency;
		} else {
			currentTime = 0;
			_frequency = MathTools.cmin(frequency, time.minimalPoint);
		}
		if (started) start();
		return this;
	}

	public inline function restart(?dt: DT): Void {
		stop();
		reset();
		start(dt);
	}

	public function start(?dt: DT): Timer {
		stop();
		var delay: Int = !eUpdate.empty || time == null ? _frequency : MathTools.cabs(time.max - currentTime);
		#if (!neko && !dox && !cpp)
		t = new haxe.Timer(delay);
		t.run = !update.empty ? _update : _complite;
		#elseif munit
		t = new massive.munit.util.Timer(delay);
		t.run = !eUpdate.empty ? _update : _complite;
		#end
		return this;
	}

	private function _complite(): Void {
		eComplete.dispatch(0);
		if (repeatCount == 0) stop();
		else if (repeatCount > 0) repeatCount--;
	}

	private function _update(): Void {
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

	public function stop(): Timer {
		#if ((!neko && !dox && !cpp) || munit)
		if (t != null) {
			t.stop();
			t = null;
		}
		#end
		return this;
	}

	public inline function dispatchUpdate(): Timer {
		eUpdate.dispatch(currentTime);
		return this;
	}

	public function destroy(): Void {
		stop();
		eProgress.destroy();
		eUpdate.destroy();
		eComplete.destroy();
		eProgress = null;
		eUpdate = null;
		eComplete = null;
		time = null;
	}

	private function _progress(): Void eProgress.dispatch(time.percent(currentTime));

	public static inline function delay(time: Time, f:Void -> Void): Timer {
		var t: Timer = new Timer(time);
		t.complete.once(f);
		t.complete.once(t.destroy);
		return t.start();
	}
	public static inline function repeat(time: Time, f: Void -> Void): Timer {
		var t: Timer = new Timer(time, -1);
		t.complete.add(f);
		return t.start();
	}

}