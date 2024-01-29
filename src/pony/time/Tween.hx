package pony.time;

import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.math.MathTools;

#if (haxe_ver >= 4.2) enum #else @:enum #end abstract TweenType(Int) {
	var Linear = 0;
	var Square = 1;
	var BackSquare = 2;
	var Bezier = 3;

	@:from public static function fromString(s: String): TweenType {
		return switch StringTools.trim(s).toLowerCase() {
			case 'linear': Linear;
			case 'square': Square;
			case 'backsquare': BackSquare;
			case 'bezier': Bezier;
			case _: throw 'Unsupported tween type';
		};
	}
}

/**
 * Tween
 * @author AxGord <axgord@gmail.com>
 */
class Tween implements HasSignal implements Declarator {

	private static inline var SECOND: UInt = 1000;
	private static inline var HALF_SECOND: UInt = 500;

	@:auto public var onUpdate: Signal1<Float>;
	@:auto public var onProgress: Signal1<Float>;
	@:auto public var onComplete: Signal1<Float>;
	@:auto public var onSkip: Signal1<Int>;

	@:arg public var range: Interval<Float> = 0...1;

	/**
	 * Next start will be backward
	 */
	private var invert: Bool;

	private var updateSignal: Signal1<DT>;
	public var time(get, set): Time;
	public var progress(default, null): Float = 0;
	private var sr: Float;
	private var playing: Bool = false;
	private var type: TweenType;
	private var skipTime: Float;

	public function new(
		type: TweenType = TweenType.Linear,
		time: Time = 1000,
		invert: Bool = false,
		loop: Bool = false,
		pingpong: Bool = false,
		fixedTime: Bool = false,
		?skipTime: Time
	) {
		this.type = type;
		this.time = time;
		sr = 1000 / time;
		this.invert = invert;
		updateSignal = fixedTime ? DeltaTime.fixedUpdate : DeltaTime.update;
		if (pingpong) {
			if (skipTime == null) skipTime = time / HALF_SECOND;
			onComplete << invertInvert;
		} else {
			if (skipTime == null) skipTime = time / SECOND;
		}
		this.skipTime = skipTime;
		onComplete << endPlay;
		if (loop) onComplete << play;
		onProgress << progressHandler;
	}

	private inline function get_time(): Time return 1000 / sr;
	private inline function set_time(time: Time): Time return sr = 1000 / time;

	private function progressHandler(v: Float): Void {
		v = switch type {
			case Linear: v;
			case Square: v * v;
			case BackSquare: 1 - Math.pow(1 - v, 2);
			case Bezier: v * v * (3 - 2 * v);
		};
		eUpdate.dispatch(MathTools.percentCalc(v, range.min, range.max));
	}

	private function invertInvert(): Void invert = !invert;
	private function endPlay(): Void playing = false;

	public function playForward(?dt: DT): Void {
		if (playing) pause();
		invert = false;
		playing = true;
		updateSignal << forward;
		if ((dt: Null<Float>) != null) forward(dt);
	}

	public function playBack(?dt: DT): Void {
		if (playing) pause();
		invert = true;
		playing = true;
		updateSignal << backward;
		if ((dt: Null<Float>) != null) backward(dt);
	}

	public function play(?dt: DT): Void {
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
			if ((dt: Null<Float>) != null) forward(dt);
		} else {
			updateSignal << backward;
			if ((dt: Null<Float>) != null) backward(dt);
		}
	}

	private function forward(dt: Float): Void {
		if (updateSignal == null) {
			DeltaTime.fixedUpdate >> forward;
			DeltaTime.update >> forward;
			return; //todo: fix bug (check this)
		}
		if (!playing) {
			//trace('forward');
			updateSignal >> forward;
			return; //todo: fix bug (check this)
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

	private function backward(dt: Float): Void {
		if (updateSignal == null) {
			DeltaTime.fixedUpdate >> backward;
			DeltaTime.update >> backward;
			return; //todo: fix bug (check this)
		}
		if (!playing) {
			//trace('backward');
			updateSignal >> backward;
			return; //todo: fix bug (check this)
		}
		progress -= dt * sr;
		if (progress <= 0) {
			updateSignal >> backward;
			var d: Float = MathTools.range(progress, 0) / sr;
			progress = 0;
			update();
			eComplete.dispatch(d);
		} else {
			update();
		}
	}

	public inline function update(): Void eProgress.dispatch(progress);

	public function pause(): Void {
		if (updateSignal == null) return;
		updateSignal.remove(invert ? backward : forward);
		playing = false;
	}

	public function stopOnBegin(): Void {
		if (updateSignal == null) return;
		pause();
		invert = false;
		progress = 0;
		update();
	}

	public function stopOnEnd(): Void {
		if (updateSignal == null) return;
		pause();
		invert = true;
		progress = 1;
		update();
	}

	public function destroy(): Void {
		pause();
		this.destroySignals();
		updateSignal = null;
		range = null;
	}

}