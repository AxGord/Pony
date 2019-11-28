package pony.ui.gui;

import pony.events.Signal1;
import pony.events.Signal2;
import pony.time.Time;
import pony.time.DTimer;
import pony.time.DT;
import pony.math.MathTools;

/**
 * AnimCore
 * @author AxGord <axgord@gmail.com>
 */
class AnimCore implements pony.magic.HasAbstract implements pony.magic.HasSignal {

	@:auto public var onFrame: Signal1<Int>;
	@:auto public var onFrameUpdate: Signal2<Int, DT>;
	@:auto public var onComplete: Signal1<DT>;
	public var totalFrames(get, never): Int;
	public var frame(default, set): Int = 0;
	public var loop: Bool = true;

	private var timer: DTimer;

	public function new(frameTime: Time, fixedTime: Bool = false) {
		timer = fixedTime ? DTimer.createFixedTimer(frameTime, -1) : DTimer.createTimer(frameTime, -1);
		timer.complete << tick;
	}

	private function tick(dt: DT): Void {
		if (frame >= totalFrames - 1) {
			if (!loop) {
				stop();
				eComplete.dispatch(dt);
				return;
			}
			frame = 0;
		} else {
			frame++;
		}
		eFrameUpdate.dispatch(frame, dt);
	}

	public inline function play(dt: DT = 0): Void timer.start(dt);

	public inline function stop(): Void {
		timer.stop();
		timer.reset();
	}

	public inline function gotoAndPlay(frame: Int, dt: DT = 0): Void {
		this.frame = frame;
		play(dt);
	}

	public inline function gotoAndStop(frame: Int): Void {
		this.frame = frame;
		stop();
	}

	public function set_frame(n: Int): Int {
		if (n < 0) n = 0;
		else if (n > totalFrames) n = totalFrames;
		if (n != frame) {
			frame = n;
			eFrame.dispatch(n);
		}
		return n;
	}

	@:abstract private function get_totalFrames(): Int;

	public function destroy(): Void {
		timer.destroy();
		timer = null;
		destroySignals();
	}

}