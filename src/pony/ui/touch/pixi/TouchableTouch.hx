package pony.ui.touch.pixi;

import js.Browser;
import pixi.core.display.Container;
import pixi.interaction.InteractionEvent;
import pony.ui.touch.pixi.Touch;

/**
 * PixiJS TouchableTouch
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.TouchableBase)
class TouchableTouch {

	private static var inited: Bool = false;

	public static function init(): Void {
		if (inited) return;
		inited = true;
		Touch.init();
		Touch.onMove << globalTouchMoveHandler;
	}

	private static function globalTouchMoveHandler(e: TouchObj): Void {
		TouchableBase.dispatchMove(e.id, e.x, e.y);
	}

	private var obj: Container;
	private var base: TouchableBase;
	private var touchId: Null<UInt> = null;
	private var over: Bool = false;
	private var down: Bool = false;
	private var needCancle: Bool = false;

	public function new(obj: Container, base: TouchableBase) {
		init();
		this.obj = obj;
		this.base = base;
		obj.on('touchstart', touchBeginHandler);
		obj.on('touchmove', touchMoveHandler);
		obj.on('touchendoutside', outsideHandler);
		Touch.onEnd << touchEndHandler;
		Touch.onCancle << cancleTouchHandler;
		Browser.window.addEventListener('orientationchange', orientationchangeHandler, true);
	}

	private function orientationchangeHandler(): Void lost(touchId);

	public function destroy(): Void {
		if (touchId != null) lost(touchId);
		obj.removeListener('touchstart', touchBeginHandler);
		obj.removeListener('touchmove', touchMoveHandler);
		obj.removeListener('touchendoutside', outsideHandler);
		Browser.window.removeEventListener('orientationchange', orientationchangeHandler, true);
		Touch.onEnd >> touchEndHandler;
		Touch.onCancle >> cancleTouchHandler;
		obj = null;
		base = null;
	}

	private function outsideHandler(e: InteractionEvent): Void {
		if (isLock(untyped e.data.identifier)) return;
		lost(untyped e.data.identifier);
	}

	private function isLock(t: UInt): Bool {
		if (isNotLock(t)) {
			touchId = t;
			return false;
		} else
			return true;
	}

	@:extern private inline function unlock(t: UInt): Void touchId = null;
	@:extern private inline function isNotLock(t: UInt): Bool return touchId == null || touchId == t;

	private function touchBeginHandler(e: InteractionEvent): Void {
		if (isLock(untyped e.data.identifier)) return;
		over = true;
		down = true;
		base.dispatchOver(untyped e.data.identifier);
		var p = Touch.correction(untyped e.data.global.x, e.data.global.y);
		base.dispatchDown(untyped e.data.identifier, p.x, p.y);
	}

	private function touchEndHandler(t: TouchObj): Void {
		if (!down) return;
		if (!isNotLock(t.id)) {
			if (down && !over) lost(t.id);
			return;
		}
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

	private function touchMoveHandler(e: InteractionEvent): Void {
		if (!down) return;
		var id = untyped e.data.identifier;
		if (isLock(id)) return;
		var p = e.data.global;
		var c = obj.getBounds().contains(p.x, p.y);
		if (over) {
			if (!c) {
				over = false;
				base.dispatchOutDown(id);
				if (needCancle) lost(id);
			}
		} else {
			if (c) {
				over = true;
				base.dispatchOverDown(id);
			}
		}
	}

	private function cancleTouchHandler(id: UInt): Void {
		if (touchId == id) {
			lost(id);
		} else if (!isNotLock(id) && down) {
			if (!over)
				lost(id);
			else
				needCancle = true;
		}
	}

	private function lost(id: UInt): Void {
		needCancle = false;
		down = false;
		over = false;
		base.dispatchOutDown(id);
		base.dispatchOutUp(id);
		unlock(id);
	}

}