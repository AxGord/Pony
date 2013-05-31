package pony.ui;
import pony.events.Event;
import pony.events.Signal;
import pony.Timer;

/**
 * ...
 * @author AxGord
 */

enum ButtonStates {
	Default; Focus; Leave; Press;
}
 
class ButtonCore {

	public static var MOUSE_FOCUS:Bool = true;
	public static var tickDelay:Int = 200;
	public static var tickFirstDelay:Int = 600;
	
	public var mouseState(default, null):ButtonStates;
	public var tabState(default, null):ButtonStates;
	public var keyboardState(default, null):ButtonStates;
	public var fakeState:ButtonStates;
	
	public var summaryState(get, null):ButtonStates;
	public var visualState(get, null):ButtonStates;
	
	private var prevSummary:ButtonStates;
	private var prevVisual:ButtonStates;
	private var prevTab:Bool;
	private var timer:Timer;
	private var prevMode:Int;
	private var waitUp:Bool;
	
	public var mode(default,set):Int;
	public var change(default, null):Signal;
	public var changeVisual(default, null):Signal;
	public var click(default, null):Signal;
	public var tick(default, null):Signal;
	public var down(default, null):Signal;
	public var up(default, null):Signal;
	public var select(default, null):Signal;
	public var unselect(default, null):Signal;
	
	public var sw(default, set):Array<Int>;
	
	public function new() {
		mouseState = Default;
		keyboardState = Default;
		tabState = Default;
		fakeState = Default;
		prevSummary = Default;
		prevVisual = Default;
		prevTab = false;
		prevMode = mode = 0;
		change = new Signal();
		changeVisual = new Signal();
		click = new Signal();
		tick = new Signal();
		down = new Signal();
		up = new Signal();
		change.add(changeState);
		waitUp = false;
	}
	
	private function set_mode(v:Int):Int {
		mode = v;
		update();
		return mode;
	}
	
	public function mouseOver(btnDown:Bool):Void {
		switch (mouseState) {
			case Default:
				if (!btnDown) {
					mouseState = Focus;
					update();
				} else {
					waitUp = true;
				}
			case Leave:
				mouseState = Press;
				update();
			default:
		}
	}
	
	public function mouseOut():Void {
		waitUp = false;
		switch (mouseState) {
			case Focus:
				mouseState = Default;
				update();
			case Press:
				mouseState = Leave;
				update();
			default:
		}
	}
	
	public function mouseUp():Void {
		switch (mouseState) {
			case Default if (waitUp):
				mouseState = Focus;
				update();
			case Leave:
				mouseState = Default;
				update();
			case Press:
				mouseState = Focus;
				update();
			default:
		}
		waitUp = false;
	}
	
	public function mouseDown():Void {
		if (mouseState != Focus) return;
		mouseState = Press;
		update();
	}
	
	public function setFocus():Void {
		if (tabState != Default) return;
		tabState = Focus;
		update();
	}
	
	public function leaveFocus():Void {
		if (tabState != Default) return;
		tabState = Default;
		update();
	}
	
	public function enterDown():Void {
		if (tabState != Focus) return;
		tabState = Press;
		update();
	}
	
	public function enterUp():Void {
		if (tabState != Press) return;
		tabState = Press;
		update();
	}
	
	public function keyDown():Void {
		if (keyboardState != Default) return;
		keyboardState = Press;
	}
	
	public function keyUp():Void {
		if (keyboardState != Press) return;
		keyboardState = Default;
	}
	
	private function get_summaryState():ButtonStates {
		return switch [mouseState, tabState, keyboardState] {
			case [Leave, a, b] if (a != Press && b != Press): Leave;
			case [_, _, Press] | [_, Press, _] | [Press, _, _]: Press;
			case [Focus, _, _]: Focus;
			default: Default;
		}
	}
	
	private function get_visualState():ButtonStates {
		return switch [summaryState, fakeState] {
			case [Press, _] | [_, Press]: Press;
			case _ if (mouseState == Focus && !MOUSE_FOCUS): Default;
			case [_, Focus] | [Focus, _]: Focus;
			case [Leave, _]: Leave;
			default: Default;
		}
	}
	
	private function update():Void {
		var f:Bool = false;
		var nt:Bool = tabState == Focus;
		if (prevTab != nt) {
			prevTab = nt;
			if (nt)
				select.dispatch();
			else
				unselect.dispatch();
			f = true;
		}
		var pmm:Bool = prevMode != mode;
		prevMode = mode;
		if (prevSummary != summaryState) {
			prevSummary = summaryState;
			change.dispatch(summaryState, mode);
		}
		if (prevVisual != visualState || f || pmm) {
			prevVisual = visualState;
			changeVisual.dispatch(visualState, mode, f);
		}
	}
	
	private function changeState(event:Event):Void {
		switch [event.prev == null ? Default : event.prev.args[0], event.args[0]] {
			case [Press, s]:
				if (s != Leave) click.dispatch(mode);
				killTimer();
				up.dispatch(mode);
			case [_, Press]:
				down.dispatch(mode);
				if (tick.haveListeners) {
					tick.dispatch(mode);
					timer = Timer.tick(tickFirstDelay);
					timer.once(tickListener);
					timer.once(beginTicks);
				}
			default:
		}
	}
	
	private function tickListener():Void tick.dispatch(mode);
	
	private function beginTicks():Void {
		timer = new Timer(tickDelay);
		timer.add(tickListener);
	}
	
	private inline function killTimer():Void {
		if (timer == null) return;
		timer.clear();
	}
	
	private function set_sw(a:Array<Int>):Array<Int> {
		if (sw != null) throw 'sw setted';
		for (i in 0...a.length)
			click.sub([i], [a[i]]).add(set_mode);
		return sw = a;
	}
	
}