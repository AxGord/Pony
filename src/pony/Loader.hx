package pony;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

/**
 * Loader
 * Organize loading for application
 * @author AxGord <axgord@gmail.com>
 */
class Loader implements HasSignal {

	@:auto public var onProgress: Signal1<Float>;
	@:auto public var onComplete: Signal0;

	public var intensivity: Int;
	public var beginWait: Int;

	private var actions: List<Void -> Void>;
	private var totalActions(default, null): Int = 0;

	public var total: Int = 0;
	public var complites: Int = 0;

	public var loaded: Bool = false;

	public function new(intensivity: Int = 10, beginWait: Int = 0) {
		this.intensivity = intensivity;
		this.beginWait = beginWait;
		actions = new List<Void -> Void>();
		onComplete.once(end);
	}

	public function init(fastLoad: Bool = false): Void {
		if (!fastLoad) {
			if (beginWait == 0)
				begin();
			else
				DeltaTime.fixedUpdate.add(wait);
		} else
			fastEnd();
	}

	private function fast(): Void {
		eComplete.dispatch();
	}

	private function wait(): Void {
		if (beginWait-- <= 0) {
			DeltaTime.fixedUpdate.remove(wait);
			begin();
		}
	}

	private inline function begin(): Void DeltaTime.fixedUpdate.add(update);

	private function update(): Void {
		for (_ in 0...intensivity) {
			#if fastload
			if (actions.length > 0)
				actions.pop();
			else
				break;
			#else
			if (actions.length > 0)
				actions.pop()();
			else
				break;
			#end
		}
		if (totalActions == 0)
			eProgress.dispatch(counterPercent());
		else if (total == 0)
			eProgress.dispatch(listPercent());
		else
			eProgress.dispatch((listPercent() + counterPercent()) / 2);
		if (actions.length == 0 && complites == total) eComplete.dispatch();
	}

	private inline function listPercent(): Float return 1 - actions.length / totalActions;

	private inline function counterPercent(): Float return complites / total;

	public function end(): Void {
		DeltaTime.fixedUpdate.remove(update);
		loaded = true;
	}

	public function addAction(f: Void -> Void): Void {
		totalActions++;
		actions.push(f);
	}

	private inline function fastEnd(): Void eComplete.dispatch();

}