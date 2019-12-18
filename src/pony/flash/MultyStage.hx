package pony.flash;

import pony.events.Signal1;
import pony.events.Listener1;
import pony.events.SignalControllerInner1;
import pony.magic.HasSignal;
import flash.display.Stage;

/**
 * MultyStage
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class MultyStage implements HasSignal {

	@:auto public static var onAdd: Signal1<Stage>;
	@:auto public static var onRemove: Signal1<Stage>;

	@:nullSafety(Off) private static var stages: Array<Stage>;

	private static function __init__(): Void {
		stages = [];
		FLTools.getStage(add);
	}

	public static function apply(applyListener: Listener1<Stage>, ?removeListener: Listener1<Stage>): Void {
		onAdd << applyListener;
		if (removeListener != null) onRemove << removeListener;
		var controller: SignalControllerInner1<Stage> = new SignalControllerInner1<Stage>(onAdd);
		for (stage in MultyStage) {
			applyListener.call(stage, controller);
			if (controller.stop) break;
		}
		controller.destroy();
	}

	public static function cancel(applyListener: Listener1<Stage>, ?removeListener: Listener1<Stage>): Void {
		onAdd >> applyListener;
		if (removeListener != null) {
			onRemove >> removeListener;
			var controller: SignalControllerInner1<Stage> = new SignalControllerInner1<Stage>(onRemove);
			for (stage in MultyStage) {
				removeListener.call(stage, controller);
				if (controller.stop) break;
			}
			controller.destroy();
		}
	}

	@:keep public static inline function add(stage: Stage): Void {
		stages.push(stage);
		eAdd.dispatch(stage);
	}

	@:keep public static inline function remove(stage: Stage): Void {
		stages.remove(stage);
		eRemove.dispatch(stage);
	}

	public static inline function iterator(): Iterator<Stage> return stages.iterator();

	#if swc
	private static function applyfn(applyListener: Stage -> Void, removeListener: Stage -> Void): Void
		apply(applyListener, removeListener);
	private static function cancelfn(applyListener: Stage -> Void, removeListener: Stage -> Void): Void
		cancel(applyListener, removeListener);
	private static function addAddListener(listener: Stage -> Void): Void onAdd << listener;
	private static function removeAddListener(listener: Stage -> Void): Void onAdd >> listener;
	private static function addRemoveListener(listener: Stage -> Void): Void onRemove << listener;
	private static function removeRemoveListener(listener: Stage -> Void): Void onRemove >> listener;
	#end

}