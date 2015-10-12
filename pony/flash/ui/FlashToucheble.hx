package pony.flash.ui;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.Lib;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import pony.events.Event0;
import pony.events.Signal0;
import pony.touchManager.TouchebleBase;

/**
 * FlashToucheble
 * @author AxGord <axgord@gmail.com>
 */
class FlashToucheble extends TouchebleBase {

	static public var touchMode(default,null):Bool = false;
	static private var globalUp:Event0;
	static private var lockOver:Int = -1;
	static private var idCounter:Int = 0;
	private var over:Bool = false;
	private var id:Int;
	
	@:extern inline private static function init():Void {
		if (globalUp != null) return;
		globalUp = new Event0();
		if (Multitouch.supportsTouchEvents) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, switchToMouse, true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, switchToTouch, true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, switchToTouch, true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, switchToTouch, true);
			
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, touchGlobalEndHandler);
		}
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, globalUpHandler);
	}
	
	private static function switchToMouse(_):Void {
		touchMode = false;
	}
		
	private static function switchToTouch(_):Void {
		touchMode = true;
	}
	
	public function new(obj:DisplayObject) {
		super();
		id = idCounter++;
		init();
		if (Multitouch.supportsTouchEvents) {
			obj.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			obj.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			obj.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchGlobalMoveHandler);
		}
		obj.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
		obj.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		obj.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		obj.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		
		(globalUp:Signal0) << eOutUp;
		onDown << function() onUp < eClick;
		onOutUp << function() onUp >> eClick;
	}
	
	@:extern inline private function isLock():Bool return lockOver != -1 && lockOver != id;
	
	private function overHandler(event:MouseEvent):Void {
		if (touchMode) return;
		if (isLock()) return;
		over = true;
		event.buttonDown ? eOverDown.dispatch() : eOver.dispatch();
	}
	
	private function outHandler(event:MouseEvent):Void {
		if (touchMode) return;
		over = false;
		event.buttonDown ? eOutDown.dispatch() : eOut.dispatch();
	}
	
	private function downHandler(_):Void {
		if (touchMode) return;
		lockOver = id;
		eDown.dispatch();
	}
	
	private function upHandler(event:MouseEvent):Void {
		if (touchMode) return;
		lockOver = -1;
		event.stopPropagation();
		if (over) eUp.dispatch();
		else {
			(globalUp:Signal0) >> eOutUp;
			globalUp.dispatch();
			(globalUp:Signal0) << eOutUp;
			over = true;
			eOver.dispatch();
		}
	}
	
	private static function globalUpHandler(_):Void {
		if (touchMode) return;
		lockOver = -1;
		globalUp.dispatch();
	}
	
	private function touchBeginHandler(_):Void {
		if (!touchMode) return;
		if (isLock()) return;
		lockOver = id;
		over = true;
		eOver.dispatch();
		eDown.dispatch();
	}
	
	private function touchEndHandler(event:TouchEvent):Void {
		if (!touchMode) return;
		event.stopPropagation();
		if (over) {
			eUp.dispatch();
			eOut.dispatch();
			over = false;
		} else {
			(globalUp:Signal0) >> eOutUp;
			globalUp.dispatch();
			(globalUp:Signal0) << eOutUp;
		}
		lockOver = -1;
	}
	
	private function touchMoveHandler(event:TouchEvent):Void {
		if (!touchMode) return;
		if (isLock()) return;
		event.stopPropagation();
		if (over) return;
		over = true;
		eOverDown.dispatch();
	}
	
	private function touchGlobalMoveHandler(_):Void {
		if (!touchMode) return;
		if (isLock()) return;
		if (!over) return;
		over = false;
		eOutDown.dispatch();
	}
	
	private static function touchGlobalEndHandler(_):Void {
		if (!touchMode) return;
		lockOver = -1;
		globalUp.dispatch();
	}

	
}