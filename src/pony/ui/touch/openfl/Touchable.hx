package pony.ui.touch.openfl;

import flash.display.DisplayObject;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import pony.events.Signal1;
import pony.time.DeltaTime;
import pony.time.DTimer;
import pony.ui.touch.lime.Touch;
import pony.ui.touch.Mouse;
import pony.ui.touch.TouchableBase;

/**
 * OpenFL Touchable
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
class Touchable extends TouchableBase {

	@:bindable public static var touchMode: Bool = false;
	public static var onAnyTouch(default, null): Signal1<lime.ui.Touch>;
	public static var touchSupport(get, null): Bool;

	private static var inited: Bool = false;
	private static var needSw: Bool = false;
	private static var wait: Bool = false;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function get_touchSupport(): Bool {
		#if touchsim
		return true;
		#elseif notouch
		return false;
		#else
		return Multitouch.supportsTouchEvents;
		#end
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function init(): Void {
		if (inited) return;
		inited = true;
		Mouse.init();
		if (touchSupport) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Touch.init();
			DeltaTime.fixedUpdate < Touch.enableStd;
			onAnyTouch = Touch.onEnd || Touch.onStart || Touch.onMove;
			firstSwitchToTouch();
			DeltaTime.fixedUpdate < Touch.enableStd;
		} else {
			DeltaTime.fixedUpdate < Mouse.enableStd;
		}
	}

	private static function switchToMouse(): Void {
		needSw = false;
		Touch.disableStd();
		onAnyTouch >> touchHandler;
		Mouse.onMove >> mouseHandler;
		onAnyTouch << switchToTouch;
		touchMode = false;
		Mouse.enableStd();
	}

	private static function switchToTouch(): Void {
		needSw = false;
		Mouse.disableStd();
		Touch.enableStd();
		firstSwitchToTouch();
		onAnyTouch >> switchToTouch;
	}

	private static function firstSwitchToTouch(): Void {
		touchMode = true;
		onAnyTouch << touchHandler;
		Mouse.onMove << mouseHandler;
	}

	private static function mouseHandler(): Void {
		if (wait) return;
		wait = true;
		needSw = true;
		DTimer.fixedDelay(500, needSwToMouse);
	}

	private static function needSwToMouse(): Void {
		wait = false;
		if (needSw) switchToMouse();
		needSw = false;
	}

	private static function touchHandler(): Void {
		needSw = false;
	}

	private var obj: DisplayObject;
	private var touch: TouchableTouch;
	private var mouse: TouchableMouse;

	public function new(obj: DisplayObject) {
		init();
		super();
		this.obj = obj;
		if (touchMode)
			touch = new TouchableTouch(obj, this);
		else
			mouse = new TouchableMouse(obj, this);
		changeTouchMode - true << toTouch;
		changeTouchMode - false << toMouse;
	}

	override public function destroy(): Void {
		changeTouchMode - true >> toTouch;
		changeTouchMode - false >> toMouse;
		obj = null;
		if (touchMode) {
			touch.destroy();
			touch = null;
		} else {
			mouse.destroy();
			mouse = null;
		}
		super.destroy();
	}

	private function toTouch(): Void {
		mouse.destroy();
		mouse = null;
		touch = new TouchableTouch(obj, this);
	}

	private function toMouse(): Void {
		touch.destroy();
		touch = null;
		mouse = new TouchableMouse(obj, this);
	}

}