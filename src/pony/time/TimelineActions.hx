package pony.time;

import pony.events.Signal;
import pony.events.Signal0;
import pony.events.Signal1;

/**
 * TimelineActions
 * @author AxGord
 */
class TimelineActions {

	public var onProccessBegin: Signal0<TimelineActions>;
	public var onProccessEnd: Signal0<TimelineActions>;
	public var onReset: Signal0<TimelineActions>;
	public var onStepBegin: Signal1<TimelineActions, Int>;
	public var onStepEnd: Signal1<TimelineActions, Int>;

	private var timeline: Timeline;
	private var toStep: Int = 0;
	private var stepSpeed: Array<Float>;
	private var superSpeed: Float;

	public function new(times: Array<Time>, speeds: Array<Float>, superSpeed: Float=10) {
		stepSpeed = speeds;
		this.superSpeed = superSpeed;
		timeline = new Timeline(times, true);
		timeline.onStep << timelineStepHandler;
		onProccessBegin = Signal.create(this);
		onProccessEnd = Signal.create(this);
		onReset = Signal.create(this);
		onStepBegin = Signal.create(this);
		onStepEnd = Signal.create(this);
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
			onStepBegin.dispatch(n);
		} else if (timeline.isPlay && n > timeline.currentStep) {
			toStep = n;
			timeline.playTo(n);
			fast();
		} else {
			timeline.reset();
			onReset.dispatch();
			onStepBegin.dispatch(0);
			if (n > 0) {
				onProccessBegin.dispatch();
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
		onStepBegin.dispatch(timeline.currentStep);
		play();
	}

	private inline function setSpeedForStep(n: Int): Void stepSpeed[n] == 0 ? pause() : setSpeed(stepSpeed[n]);

	private function timelineStepHandler(n: Int): Void {
		if (n > toStep) {
			pause();
		} else if (n == toStep) {
			setSpeedForStep(n);
			if (stepSpeed[n] > 0) timeline.play();
			onStepBegin.dispatch(n);
			onProccessEnd.dispatch();
		}
		onStepEnd.dispatch(n-1);
	}

}