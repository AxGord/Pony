package pony.ui;

import pony.events.SignalControllerInner0;
import pony.events.Listener0;
import pony.events.Signal0;
import pony.magic.HasSignal;
import pony.ui.touch.Mouse;
import pony.ui.touch.Touchable;
import pony.ui.keyboard.Keyboard;
import pony.time.DTimer;
import pony.time.Time;

/**
 * TimeoutActivity
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class TimeoutActivity implements HasSignal {

	@:auto public var onIdle: Signal0;
	@:auto public var onWakeup: Signal0;
	public var sleep(default, null): Bool = false;

	private var timer: DTimer;

	public function new(timeout: Time) {
		timer = DTimer.createFixedTimer(timeout);
		timer.start();
		timer.complete << idle;
		Keyboard.down << wakeup;
		Keyboard.up << wakeup;
		Mouse.onWheel << wakeup;
		Mouse.onMove << wakeup;
		Mouse.onLeftDown << wakeup;
		Mouse.onLeftUp << wakeup;
		Mouse.onMiddleDown << wakeup;
		Mouse.onMiddleUp << wakeup;
		Mouse.onRightDown << wakeup;
		Mouse.onRightUp << wakeup;
		#if (flash && !starling)
		if (Touchable.touchSupport) Touchable.onAnyTouch << wakeup;
		#end
	}

	public function idle(): Void {
		if (!sleep) {
			sleep = true;
			timer.stop();
			eIdle.dispatch();
		}
	}

	public function wakeup(): Void {
		timer.reset();
		if (sleep) {
			sleep = false;
			timer.start();
			eWakeup.dispatch();
		}
	}

	public function applyIdle(listener: Listener0): Void {
		onIdle << listener;
		if (sleep) {
			var c: SignalControllerInner0 = new SignalControllerInner0(onIdle);
			listener.call(c);
			c.destroy();
		}
	}

	public function applyWakeup(listener: Listener0): Void {
		onWakeup << listener;
		if (!sleep) {
			var c: SignalControllerInner0 = new SignalControllerInner0(onWakeup);
			listener.call(c);
			c.destroy();
		}
	}

	public function destroy(): Void {
		destroySignals();
		timer.destroy();
	}

	#if swc
	public function applyIdleFn(listener: Void -> Void): Void applyIdle(listener);
	public function applyWakeupFN(listener: Void -> Void): Void applyWakeup(listener);
	public function addIdleListener(listener: Void -> Void): Void onIdle << listener;
	public function removeIdleListener(listener: Void -> Void): Void onIdle >> listener;
	public function addWakeupListener(listener: Void -> Void): Void onWakeup << listener;
	public function removeWakeupListener(listener: Void -> Void): Void onWakeup >> listener;
	#end

}