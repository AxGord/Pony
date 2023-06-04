package pony.ui.touch;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.geom.Direction;
import pony.geom.Point;
import pony.magic.HasSignal;
import pony.time.DTimer;
import pony.time.Time;
import pony.TypedPool;

/**
 * Touchable
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety class TouchableBase implements HasSignal {

	public static var touchScreen(get, never): Bool;

	private static inline var SWIPE_DELAY: Time = 50;
	private static inline var SWIPE_STEP: UInt = 4;
	private static inline var SWIPE_REPEATS: UInt = 8;
	private static inline var TAP_DELAY: Time = 300;

	private static var touches: Map<UInt, Touch> = new Map<UInt, Touch>();
	private static var touchPool: TypedPool<Touch> = new TypedPool<Touch>();

	@:auto public var onOver: Signal1<Touch>;
	@:auto public var onOut: Signal1<Touch>;
	@:auto public var onOutUp: Signal1<Touch>;
	@:auto public var onOutRightUp: Signal1<Touch>;
	@:auto public var onOverDown: Signal1<Touch>;
	@:auto public var onOverRightDown: Signal1<Touch>;
	@:auto public var onOutDown: Signal1<Touch>;
	@:auto public var onOutRightDown: Signal1<Touch>;
	@:auto public var onDown: Signal1<Touch>;
	@:auto public var onRightDown: Signal1<Touch>;
	@:auto public var onUp: Signal1<Touch>;
	@:auto public var onRightUp: Signal1<Touch>;
	@:auto public var onClick: Signal1<Touch>;
	@:auto public var onRightClick: Signal1<Touch>;
	@:auto public var onTap: Signal1<Touch>;
	@:auto public var onWheel: Signal1<Float>;
	@:auto public var onSwipe: Signal1<Direction>;

	@:nullSafety(Off) private var tapTimer: DTimer;
	@:nullSafety(Off) private var tapTouch: Touch;
	@:nullSafety(Off) private var swipeTimer: DTimer;
	@:nullSafety(Off) private var swipeTouch: Touch;
	@:nullSafety(Off) private var swipePoint: Point<Float>;

	public function new() {
		onDown << downHandlerWaitClick;
		onOutUp << outUpHandlerStopWaitClick;
		onRightDown << downRightHandlerWaitClick;
		onOutRightUp << outUpRightHandlerStopWaitClick;

		eTap.onTake << eTapTake;
		eTap.onLost << eTapLost;

		eWheel.onTake << addWheel;
		eWheel.onLost << removeWheel;

		eSwipe.onTake << addSwipe;
		eSwipe.onLost << removeSwipe;
	}

	private function downHandlerWaitClick(): Void onUp < eClick;
	private function outUpHandlerStopWaitClick(): Void onUp >> eClick;
	private function downRightHandlerWaitClick(): Void onRightUp < eRightClick;
	private function outUpRightHandlerStopWaitClick(): Void onRightUp >> eRightClick;

	private function addSwipe(): Void {
		swipeTimer = DTimer.createFixedTimer(SWIPE_DELAY);
		swipeTimer.complete << checkSwipe;
		onDown < listenSwipe;
	}

	private function removeSwipe(): Void {
		onDown >> listenSwipe;
		cancleSwipe();
		swipeTimer.destroy();
		@:nullSafety(Off) swipeTimer = null;
	}

	private function listenSwipe(t: Touch): Void {
		swipePoint = new Point(t.x, t.y);
		onDown >> listenSwipe;
		swipeTouch = t;
		swipeTimer.repeatCount = SWIPE_REPEATS;
		swipeTimer.start();
		t.onUp < cancleSwipeAndListenDown;
		t.onOutUp < cancleSwipeAndListenDown;
	}

	private function checkSwipe(): Void {
		var x = swipePoint.x - swipeTouch.x;
		var y = swipePoint.y - swipeTouch.y;
		var ax = Math.abs(x);
		var ay = Math.abs(y);
		if (ax > ay) {
			if (ax >= SWIPE_STEP) {
				onUp >> eClick;
				eSwipe.dispatch(x > 0 ? Direction.Left : Direction.Right);
				cancleSwipeAndListenDown();
				return;
			}
		} else if (ax < ay) {
			if (ay >= SWIPE_STEP) {
				onUp >> eClick;
				eSwipe.dispatch(y > 0 ? Direction.Up : Direction.Down);
				cancleSwipeAndListenDown();
				return;
			}
		}
		if (swipeTimer.repeatCount == 0)
			cancleSwipeAndListenDown();
	}

	private function cancleSwipeAndListenDown(): Void {
		cancleSwipe();
		if (swipeTimer != null) onDown < listenSwipe;
	}

	private function cancleSwipe(): Void {
		if (swipeTimer != null) {
			swipeTimer.stop();
			swipeTimer.reset();
		}
		if (swipeTouch != null) {
			swipeTouch.onUp >> cancleSwipeAndListenDown;
			swipeTouch.onOutUp >> cancleSwipeAndListenDown;
			@:nullSafety(Off) swipeTouch = null;
		}
		@:nullSafety(Off) swipePoint = null;
	}

	private function addWheel(): Void {
		onOver << listenWheel;
		onUp << listenWheel;
		onOut << unlistenWheel;
		onOutUp << unlistenWheel;
	}

	private function removeWheel(): Void {
		if (onOver != null) onOver >> listenWheel;
		if (onUp != null) onUp >> listenWheel;
		if (onOut != null) onOut >> unlistenWheel;
		if (onOutUp != null) onOutUp >> unlistenWheel;
	}

	private function listenWheel(): Void Mouse.onWheel << eWheel;
	private function unlistenWheel(): Void Mouse.onWheel >> eWheel;

	private function eTapTake(): Void {
		tapTimer = DTimer.createFixedTimer(TAP_DELAY);
		tapTimer.complete << cancleTap;
		onDown < beginTap;
	}

	private function eTapLost(): Void {
		if (tapTouch != null) removeTapCancle();
		tapTimer.destroy();
		@:nullSafety(Off) tapTimer = null;
		onDown >> beginTap;
	}

	private function beginTap(t: Touch): Void {
		tapTouch = t;
		tapTimer.start();
		onUp < tapHandler;
		t.onMove < tapFirstMove;
	}

	private function tapFirstMove(): Void {
		tapTouch.onMove < cancleTap;
	}

	private function tapHandler(t: Touch): Void {
		removeTapCancle();
		onDown < beginTap;
		eTap.dispatch(t);
	}

	private function cancleTap(): Void {
		removeTapCancle();
		onDown < beginTap;
	}

	private function removeTapCancle(): Void {
		onUp >> tapHandler;
		tapTimer.stop();
		tapTimer.reset();
		tapTouch.onMove >> tapFirstMove;
		tapTouch.onMove >> cancleTap;
		@:nullSafety(Off) tapTouch = null;
	}

	public function destroy(): Void {
		unlistenWheel();
		if (tapTimer != null) eTapLost();
		eTap.onTake >> eTapTake;
		eTap.onLost >> eTapLost;
		destroySignals();
	}

	/**
	 * Use this method if object has moved
	 */
	public function check(): Void {}

	private function dispatchDown(id: UInt = 0, x: Float, y: Float, right: Bool = false, safe: Bool = false): Void {
		var t: Null<Touch> = touches[id];
		if (t != null)
			@:privateAccess t.eDown.dispatch(t.set(x, y));
		else
			touches[id] = t = @:privateAccess touchPool.get().set(x, y);
		if (right)
			eRightDown.dispatchWithFlag(t, safe);
		else
			eDown.dispatchWithFlag(t, safe);
	}

	private function dispatchUp(id: UInt = 0, right: Bool = false, safe: Bool = false): Void {
		var t: Null<Touch> = touches[id];
		if (t == null) return;
		@:privateAccess t.eUp.dispatch(t);
		if (right)
			eRightUp.dispatchWithFlag(t, safe);
		else
			eUp.dispatchWithFlag(t, safe);
	}

	private function dispatchOver(id: UInt = 0, safe: Bool = false): Void {
		var t: Null<Touch> = touches[id];
		if (t != null) {
			@:privateAccess t.eOver.dispatch(t);
		} else {
			if (touchPool == null || touchPool.isDestroy) return;
			touches[id] = t = touchPool.get();
		}
		eOver.dispatchWithFlag(t, safe);
	}

	public function getTouch(id: UInt = 0): Touch {
		var t: Null<Touch> = touches[id];
		if (t == null)
			touches[id] = t = touchPool.get();
		return t;
	}

	public function retTouch(id: UInt = 0): Void {
		removeTouch(id);
	}

	private function dispatchOutDown(id: UInt = 0, right:  Bool = false, safe: Bool = false): Void {
		var t: Null<Touch> = touches[id];
		if (t == null) return;
		@:privateAccess t.eOutDown.dispatch(t);
		if (right)
			eOutRightDown.dispatchWithFlag(t, safe);
		else
			eOutDown.dispatchWithFlag(t, safe);
	}

	private function dispatchOverDown(id: UInt = 0, right:  Bool = false, safe: Bool = false): Void {
		var t: Null<Touch> = touches[id];
		if (t != null)
			@:privateAccess t.eOverDown.dispatch(t);
		else
			touches[id] = t = touchPool.get();
		if (right)
			eOverRightDown.dispatchWithFlag(t, safe);
		else
			eOverDown.dispatchWithFlag(t, safe);
	}

	private function dispatchOut(id: UInt = 0, safe: Bool = false): Void {
		var t: Null<Touch> = touches[id];
		if (t == null) return;
		@:privateAccess t.eOut.dispatch(t);
		eOut.dispatchWithFlag(t, safe);
		removeTouch(id);
	}

	private function dispatchOutUpListener(id: UInt): Void dispatchOutUp(id);

	private function dispatchOutUp(id: UInt = 0, right: Bool = false, safe: Bool = false): Void {
		var t: Null<Touch> = touches[id];
		if (t == null) return;
		@:privateAccess t.eOutUp.dispatch(t);
		if (right)
			eOutRightUp.dispatchWithFlag(t, safe);
		else
			eOutUp.dispatchWithFlag(t, safe);
		removeTouch(id);
	}

	private static function dispatchMove(id: UInt = 0, x: Float, y: Float): Void {
		var t: Null<Touch> = touches[id];
		if (t != null)
			@:privateAccess t.eMove.dispatch(t.set(x, y));
	}

	private static function removeTouch(id: UInt): Void {
		if (id == 0) return;
		var t: Null<Touch> = touches[id];
		if (t == null) return;
		t.clear();
		touchPool.ret(t);
		touches.remove(id);
	}

	private static inline function get_touchScreen(): Bool return #if ios true; #else false; #end

}