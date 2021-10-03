package pony.time;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.magic.HasSignal;

/**
 * TimelineActions
 * @author AxGord <axgord@gmail.com>
 */
class TimelineActions implements HasSignal {

	@:auto public var onProccessBegin: Signal0;
	@:auto public var onProccessEnd: Signal0;
	@:auto public var onReset: Signal0;
	@:auto public var onStepBegin: Signal1<Int>;
	@:auto public var onStepEnd: Signal1<Int>;

	private var timeline: Timeline;
	private var toStep: Int = 0;
	private var stepSpeed: Array<Float>;
	private var superSpeed: Float;

	public function new(times: Array<Time>, speeds: Array<Float>, superSpeed: Float=10) {
		stepSpeed = speeds;
		this.superSpeed = superSpeed;
		timeline = new Timeline(times, true);
		timeline.onStep << timelineStepHandler;
	}

	public dynamic function setSpeed(v: Float): Void {}
	public dynamic function pause(): Void {}
	public dynamic function play(): Void {}

	public inline function reset(): Void timeline.reset();

	private function fast(): Void {
		setSpeed(superSpeed);
		play();
	}

	public function jumpTo(n: Int): Void {
		if (!timeline.isPlay && n == timeline.currentStep) {
			toStep = n;
			play();
			setSpeedForStep(n);
			if (stepSpeed[n] > 0) timeline.play();
			eStepBegin.dispatch(n);
		} else if (timeline.isPlay && n > timeline.currentStep) {
			toStep = n;
			timeline.playTo(n);
			fast();
		} else {
			timeline.reset();
			eReset.dispatch();
			eStepBegin.dispatch(0);
			if (n > 0) {
				eProccessBegin.dispatch();
				toStep = n;
				timeline.playTo(n);
				fast();
			} else {
				toStep = 0;
				timeline.play();
				setSpeedForStep(0);
				play();
			}
		}
	}

	public function playNext(): Void {
		setSpeedForStep(timeline.currentStep);
		if (stepSpeed[timeline.currentStep] > 0) timeline.play();
		eStepBegin.dispatch(timeline.currentStep);
		play();
	}

	private inline function setSpeedForStep(n: Int): Void stepSpeed[n] == 0 ? pause() : setSpeed(stepSpeed[n]);

	private function timelineStepHandler(n: Int): Void {
		if (n > toStep) {
			pause();
		} else if (n == toStep) {
			setSpeedForStep(n);
			if (stepSpeed[n] > 0) timeline.play();
			eStepBegin.dispatch(n);
			eProccessEnd.dispatch();
		}
		eStepEnd.dispatch(n-1);
	}

}