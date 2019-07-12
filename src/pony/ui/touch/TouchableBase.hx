package pony.ui.touch;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.geom.Direction;
import pony.geom.Point;
import pony.magic.HasSignal;
import pony.time.DTimer;
import pony.TypedPool;

/**
 * Touchable
 * @author AxGord <axgord@gmail.com>
 */
class TouchableBase implements HasSignal {

	private static var touches:Map<UInt, Touch> = new Map<UInt, Touch>();
	private static var touchPool:TypedPool<Touch> = new TypedPool<Touch>();
	
	@:auto public var onOver:Signal1<Touch>;
	@:auto public var onOut:Signal1<Touch>;
	@:auto public var onOutUp:Signal1<Touch>;
	@:auto public var onOutRightUp:Signal1<Touch>;
	@:auto public var onOverDown:Signal1<Touch>;
	@:auto public var onOverRightDown:Signal1<Touch>;
	@:auto public var onOutDown:Signal1<Touch>;
	@:auto public var onOutRightDown:Signal1<Touch>;
	@:auto public var onDown:Signal1<Touch>;
	@:auto public var onRightDown:Signal1<Touch>;
	@:auto public var onUp:Signal1<Touch>;
	@:auto public var onRightUp:Signal1<Touch>;
	@:auto public var onClick:Signal1<Touch>;
	@:auto public var onRightClick:Signal1<Touch>;
	@:auto public var onTap:Signal1<Touch>;
	@:auto public var onWheel:Signal1<Int>;
	@:auto public var onSwipe:Signal1<Direction>;
	
	private var tapTimer:DTimer;
	private var tapTouch:Touch;
	private var swipeTimer:DTimer;
	private var swipeTouch:Touch;
	private var swipePoint:Point<Float>;
	
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
	
	private function addSwipe():Void {
		swipeTimer = DTimer.createFixedTimer(50);
		swipeTimer.complete << checkSwipe;
		onDown < listenSwipe;
	}
	
	private function removeSwipe():Void {
		onDown >> listenSwipe;
		cancleSwipe();
		swipeTimer.destroy();
		swipeTimer = null;
	}
	
	private function listenSwipe(t:Touch):Void {
		swipePoint = new Point(t.x, t.y);
		onDown >> listenSwipe;
		swipeTouch = t;
		swipeTimer.repeatCount = 8;
		swipeTimer.start();
		t.onUp < cancleSwipeAndListenDown;
		t.onOutUp < cancleSwipeAndListenDown;
	}
	
	private function checkSwipe():Void {
		var x = swipePoint.x - swipeTouch.x;
		var y = swipePoint.y - swipeTouch.y;
		var ax = Math.abs(x);
		var ay = Math.abs(y);
		if (ax > ay) {
			if (ax >= 4) {
				onUp >> eClick;
				eSwipe.dispatch(x > 0 ? Direction.left : Direction.right);
				cancleSwipeAndListenDown();
				return;
			}
		} else if (ax < ay) {
			if (ay >= 4) {
				onUp >> eClick;
				eSwipe.dispatch(y > 0 ? Direction.up : Direction.down);
				cancleSwipeAndListenDown();
				return;
			}
		}
		if (swipeTimer.repeatCount == 0)
			cancleSwipeAndListenDown();
	}
	
	private function cancleSwipeAndListenDown():Void {
		cancleSwipe();
		if (swipeTimer != null) onDown < listenSwipe;
	}
	
	private function cancleSwipe():Void {
		if (swipeTimer != null) {
			swipeTimer.stop();
			swipeTimer.reset();
		}
		if (swipeTouch != null) {
			swipeTouch.onUp >> cancleSwipeAndListenDown;
			swipeTouch.onOutUp >> cancleSwipeAndListenDown;
			swipeTouch = null;
		}
		swipePoint = null;
	}
	
	private function addWheel():Void {
		onOver << listenWheel;
		onUp << listenWheel;
		onOut << unlistenWheel;
		onOutUp << unlistenWheel;
	}
	
	private function removeWheel():Void {
		if (onOver != null) onOver >> listenWheel;
		if (onUp != null) onUp >> listenWheel;
		if (onOut != null) onOut >> unlistenWheel;
		if (onOutUp != null) onOutUp >> unlistenWheel;
	}
	
	private function listenWheel():Void Mouse.onWheel << eWheel;
	private function unlistenWheel():Void Mouse.onWheel >> eWheel;
	
	private function eTapTake():Void {
		tapTimer = DTimer.createFixedTimer(300);
		tapTimer.complete << cancleTap;
		onDown < beginTap;
	}
	
	private function eTapLost():Void {
		if (tapTouch != null) removeTapCancle();
		tapTimer.destroy();
		tapTimer = null;
		onDown >> beginTap;
	}
	
	private function beginTap(t:Touch):Void {
		tapTouch = t;
		tapTimer.start();
		onUp < tapHandler;
		t.onMove < tapFirstMove;
	}
	
	private function tapFirstMove():Void {
		tapTouch.onMove < cancleTap;
	}
	
	private function tapHandler(t:Touch):Void {
		removeTapCancle();
		onDown < beginTap;
		eTap.dispatch(t);
	}
	
	private function cancleTap():Void {
		removeTapCancle();
		onDown < beginTap;
	}
	
	private function removeTapCancle():Void {
		onUp >> tapHandler;
		tapTimer.stop();
		tapTimer.reset();
		tapTouch.onMove >> tapFirstMove;
		tapTouch.onMove >> cancleTap;
		tapTouch = null;
	}
	
	public function destroy():Void {
		unlistenWheel();
		if (tapTimer != null) eTapLost();
		eTap.onTake >> eTapTake;
		eTap.onLost >> eTapLost;
		destroySignals();
	}
	
	/**
	 * Use this method if object has moved
	 */
	public function check():Void {}
	
	private function dispatchDown(id:UInt = 0, x:Float, y:Float, right:Bool = false, safe:Bool = false):Void {
		if (touches.exists(id)) 
			@:privateAccess touches[id].eDown.dispatch(touches[id].set(x, y));
		else
			touches[id] = @:privateAccess touchPool.get().set(x, y);
		if (right)
			eRightDown.dispatch(touches[id], safe);
		else
			eDown.dispatch(touches[id], safe);
	}
	
	private function dispatchUp(id:UInt = 0, right:Bool = false, safe:Bool = false):Void {
		if (!touches.exists(id)) return;
		@:privateAccess touches[id].eUp.dispatch(touches[id]);
		if (right)
			eRightUp.dispatch(touches[id], safe);
		else
			eUp.dispatch(touches[id], safe);
	}
	
	private function dispatchOver(id:UInt = 0, safe:Bool = false):Void {
		if (touches.exists(id)) 
			@:privateAccess touches[id].eOver.dispatch(touches[id]);
		else
			touches[id] = touchPool.get();
		eOver.dispatch(touches[id], safe);
	}

	public function getTouch(id:UInt = 0):Touch {
		if (!touches.exists(id))
			touches[id] = touchPool.get();
		return touches[id];
	}

	public function retTouch(id:UInt = 0):Void {
		removeTouch(id);
	}
	
	private function dispatchOutDown(id:UInt = 0, right: Bool = false, safe:Bool = false):Void {
		if (!touches.exists(id)) return;
		@:privateAccess touches[id].eOutDown.dispatch(touches[id]);
		if (right)
			eOutRightDown.dispatch(touches[id], safe);
		else
			eOutDown.dispatch(touches[id], safe);
	}
	
	private function dispatchOverDown(id:UInt = 0, right: Bool = false, safe:Bool = false):Void {
		if (touches.exists(id))
			@:privateAccess touches[id].eOverDown.dispatch(touches[id]);
		else
			touches[id] = touchPool.get();
		if (right)
			eOverRightDown.dispatch(touches[id], safe);
		else
			eOverDown.dispatch(touches[id], safe);
	}
	
	private function dispatchOut(id:UInt = 0, safe:Bool = false):Void {
		if (!touches.exists(id)) return;
		@:privateAccess touches[id].eOut.dispatch(touches[id]);
		eOut.dispatch(touches[id], safe);
		removeTouch(id);
	}
	
	private function dispatchOutUpListener(id:UInt):Void dispatchOutUp(id);
	
	private function dispatchOutUp(id:UInt = 0, right:Bool = false, safe:Bool = false):Void {
		if (touches.exists(id))
			@:privateAccess touches[id].eOutUp.dispatch(touches[id]);
		if (right)
			eOutRightUp.dispatch(touches[id], safe);
		else
			eOutUp.dispatch(touches[id], safe);
		removeTouch(id);
	}
	
	private static function dispatchMove(id:UInt = 0, x:Float, y:Float):Void {
		if (touches.exists(id))
			@:privateAccess touches[id].eMove.dispatch(touches[id].set(x, y));
	}
	
	private static function removeTouch(id:UInt):Void {
		if (id == 0 || !touches.exists(id)) return;
		touches[id].clear();
		touchPool.ret(touches[id]);
		touches.remove(id);
	}
	
}