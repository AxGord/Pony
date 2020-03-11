package pony.time;

import pony.events.Signal1;
import pony.events.Listener1;
import pony.magic.Declarator;
import pony.magic.HasSignal;

/**
 * DeltaTime Timer
 * Can work as Clock
 * @author AxGord <axgord@gmail.com>
 */
class DTimer implements HasSignal implements ITimer<DTimer> implements Declarator {

	private static inline var MINIMAL_TIME_STEP: Float = 0.001;

	public var currentTime: Time;

	@:auto public var update: Signal1<Time>;
	@:auto public var progress: Signal1<Float>;
	@:auto public var complete: Signal1<DT>;

	private var sumdt: DT = 0;

	@:arg private var updateSignal: Signal1<DT>;
	@:arg public var time: TimeInterval = null;
	public var repeatCount(default, set): Int = 0;

	private var repeatCounter: Int;

	public function new(repeatCount: Int = 0) {
		this.repeatCount = repeatCount;
		eProgress.onTake.add(takeProgress);
		eProgress.onLost.add(lostProgress);
		reset();
	}

	public inline function set_repeatCount(value: Int): Int {
		repeatCount = value;
		repeatCounter = value;
		return value;
	}

	private function takeProgress(): Void update.add(_progress);
	private function lostProgress(): Void update.remove(_progress);

	public function reset(): DTimer {
		repeatCounter = repeatCount;
		currentTime = time != null ? time.min : 0;
		return this;
	}

	public function start0(): Void start(0);

	public inline function start(?dt: DT): DTimer {
		updateSignal.add(_update);
		if ((dt: Null<Float>) != null)
			@:nullSafety(Off) _update(dt);
		return this;
	}

	public inline function stop(): DTimer {
		updateSignal.remove(_update);
		return this;
	}

	private function _update(dt: DT): Void {
		sumdt += dt;
		if (sumdt >= MINIMAL_TIME_STEP) {
			var t: Time = sumdt.toTime();
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

	private function loop(): Bool {
		if (eComplete == null) return true;
		var result: Bool = false;
		var d: DT = Math.abs(currentTime - time.max) / 1000 + sumdt;
		if (repeatCounter > 0) {
			currentTime -= time.length;
			repeatCounter--;
		} else if (repeatCounter == -1) {
			currentTime -= time.length;
		} else {
			currentTime = time.max;
			stop();
			result = true;
		}
		eComplete.dispatch(d);
		return result;
	}

	public inline function dispatchUpdate(): DTimer {
		if (update != null) eUpdate.dispatch(currentTime);
		return this;
	}

	public function destroy(): Void {
		if (update == null) return;
		eProgress.onTake.remove(takeProgress);
		eProgress.onLost.remove(lostProgress);
		destroySignals();
		time = null;
	}

	private function _progress(): Void eProgress.dispatch(time.percent(currentTime));

	public inline function toString(): String return currentTime;

	public static inline function createTimer(time: TimeInterval, repeat: Int = 0): DTimer
		return new DTimer(DeltaTime.update, time, repeat);

	public static inline function createFixedTimer(time: TimeInterval, repeat: Int = 0): DTimer
		return new DTimer(DeltaTime.fixedUpdate, time, repeat);

	public static inline function delay(time: Time, f: Listener1<DT>, ?dt: DT): DTimer {
		var t: DTimer = DTimer.createTimer(time);
		t.complete.once(f);
		t.complete.once(t.destroy);
		t.start(dt);
		return t;
	}

	public static inline function fixedDelay(time: Time, f: Listener1<DT>, ?dt: DT): DTimer {
		var t: DTimer = DTimer.createFixedTimer(time);
		t.complete.once(f);
		t.complete.once(t.destroy);
		t.start(dt);
		return t;
	}

	public static inline function repeat(time: Time, f: Listener1 < DT >, ?dt: DT): DTimer {
		var t: DTimer = DTimer.createTimer(time, -1);
		t.complete.add(f);
		t.start(dt);
		return t;
	}
	public static inline function fixedRepeat(time: Time, f: Listener1 < DT >, ?dt: DT): DTimer {
		var t: DTimer = DTimer.createFixedTimer(time, -1);
		t.complete.add(f);
		t.start(dt);
		return t;
	}

	public static inline function clock(time: Time): DTimer {
		var t: DTimer = createTimer(null);
		t.currentTime = time;
		t.start();
		return t;
	}

	public static inline function fixedClock(time: Time): DTimer {
		var t: DTimer = createFixedTimer(null);
		t.currentTime = time;
		t.start();
		return t;
	}
}