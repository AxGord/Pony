package pony.ui.touch.flash;

import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.Event;
import flash.events.TouchEvent;
import flash.Lib;
import pony.flash.FLTools;
import pony.ui.touch.flash.Touch;

/**
 * Flash TouchableTouch
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.TouchableBase)
class TouchableTouch {

	private static var inited: Bool = false;

	private var touchId: Int = -1;
	private var over: Bool = false;
	private var down: Bool = false;
	private var obj: DisplayObject;
	private var base: TouchableBase;

	public function new(obj: DisplayObject, base: TouchableBase) {
		init();
		this.obj = obj;
		this.base = base;
		obj.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler, false, 0, true);
		obj.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler, false, 0, true);
		if (obj.stage != null)
			obj.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchGlobalMoveHandler, false, 0, true);
		else
			obj.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		Touch.onEnd << touchEndHandler;
	}

	public function destroy(): Void {
		if (touchId != -1) lost(touchId);
		obj.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
		obj.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
		if (obj.stage != null)
			obj.stage.removeEventListener(TouchEvent.TOUCH_MOVE, touchGlobalMoveHandler);
		else
			obj.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		Touch.onEnd >> touchEndHandler;
		obj = null;
		base = null;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function unlock(t: Int): Void touchId = -1;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function isNotLock(t: Int): Bool return touchId == -1 || touchId == t;

	private function addedToStageHandler(_): Void {
		obj.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		obj.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchGlobalMoveHandler, false, 0, true);
	}

	private function isLock(t: Int): Bool {
		if (!isNotLock(t)) return true;
		touchId = t;
		return false;
	}

	private function touchBeginHandler(e: TouchEvent): Void {
		if (isLock(e.touchPointID)) return;
		over = true;
		down = true;
		base.dispatchOver(e.touchPointID);
		base.dispatchDown(e.touchPointID, e.stageX, e.stageY);
	}

	private function touchEndHandler(t: TO): Void {
		if (!down) return;
		if (!isNotLock(t.id)) return;
		if (over) {
			base.dispatchUp(t.id);
			base.dispatchOut(t.id);
		} else {
			base.dispatchOutUp(t.id);
		}
		over = false;
		down = false;
		unlock(t.id);
	}

	private function touchMoveHandler(e: TouchEvent): Void {
		if (!down) return;
		if (isLock(e.touchPointID)) return;
		e.stopPropagation();
		if (over) return;
		over = true;
		base.dispatchOverDown(e.touchPointID);
	}

	private function touchGlobalMoveHandler(e: TouchEvent): Void {
		if (!over) return;
		if (!isNotLock(e.touchPointID)) return;
		over = false;
		base.dispatchOutDown(e.touchPointID);
		if (!down) unlock(e.touchPointID);
	}

	private function cancleTouchHandler(id: Int): Void {
		if (!isNotLock(id)) return;
		lost(id);
	}

	private function lost(id: Int): Void {
		down = false;
		over = false;
		base.dispatchOutDown(id);
		base.dispatchOutUp(id);
		unlock(id);
	}

	public static function init(): Void {
		if (inited) return;
		inited = true;
		FLTools.getStage(getStageHandler);
	}

	private static function getStageHandler(stage: Stage): Void {
		stage.addEventListener(TouchEvent.TOUCH_MOVE, globalTouchMoveHandler, false, 0, true);
	}

	private static function globalTouchMoveHandler(e: TouchEvent): Void {
		TouchableBase.dispatchMove(e.touchPointID, e.stageX, e.stageY);
	}

}
