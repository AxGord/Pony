package pony.ui.touch.pixi;

import pixi.core.display.Container;
import pony.events.Signal1;
import pony.time.DeltaTime;
import pony.time.DTimer;
import pony.ui.touch.pixi.Touch;
import pony.ui.touch.TouchableBase;

/**
 * Touchable
 * @author AxGord <axgord@gmail.com>
 */
class Touchable extends TouchableBase {

	@:bindable static public var touchMode:Bool = false;
	public static var onAnyTouch(default, null):Signal1<TouchObj>;
	
	private static var inited:Bool = false;
	private static var needSw:Bool = false;
	private static var wait:Bool = false;
	
	@:extern inline private static function init():Void {
		if (inited) return;
		inited = true;
		Mouse.init();
		Touch.init();
		onAnyTouch = Touch.onEnd || Touch.onStart || Touch.onMove;
		firstSwitchToTouch();
	}
	
	private static function switchToMouse():Void {
		needSw = false;
		onAnyTouch >> touchHandler;
		pony.ui.touch.Mouse.onMove >> mouseHandler;
		onAnyTouch << switchToTouch;
		touchMode = false;
	}
	
	private static function switchToTouch():Void {
		needSw = false;
		firstSwitchToTouch();
		onAnyTouch >> switchToTouch;
	}
	
	private static function firstSwitchToTouch():Void {
		touchMode = true;
		onAnyTouch << touchHandler;
		pony.ui.touch.Mouse.onMove << mouseHandler;
	}
	
	private static function mouseHandler():Void {
		if (wait) return;
		wait = true;
		needSw = true;
		DTimer.fixedDelay(500, needSwToMouse);
	}
	
	private static function needSwToMouse():Void {
		wait = false;
		if (needSw) switchToMouse();
		needSw = false;
	}
		
	private static function touchHandler():Void {
		needSw = false;
	}
	
	private var obj:Container;
	private var touch:TouchableTouch;
	private var mouse:TouchableMouse;
	
	public function new(obj:Container) {
		init();
		super();
		this.obj = obj;
		obj.interactive = true;
		if (touchMode)
			touch = new TouchableTouch(obj, this);
		else
			mouse = new TouchableMouse(obj, this);
		changeTouchMode - true << toTouch;
		changeTouchMode - false << toMouse;
	}
	
	override public function destroy():Void {
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
	
	private function toTouch():Void {
		mouse.destroy();
		mouse = null;
		touch = new TouchableTouch(obj, this);
	}
	
	private function toMouse():Void {
		touch.destroy();
		touch = null;
		mouse = new TouchableMouse(obj, this);
	}
	
}