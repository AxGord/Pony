package pony.ui.gui;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.ui.touch.TouchableBase;

enum ButtonState {
	Default; Focus; Leave; Press;
}

/**
 * ButtonCore
 * @author AxGord <axgord@gmail.com>
 */
class ButtonCore extends Tumbler implements HasSignal {

	public var touch:TouchableBase;
	@:auto public var onClick:Signal1<Int>;
	@:auto public var onVisual:Signal2<Int, ButtonState>;
	@:bindable public var lowMode:Int = 0;
	@:bindable public var mode:Int = 0;
	@:bindable public var bMode:Bool = false;
	@:bindable public var state:ButtonState = Default;
	
	private var modeBeforeDisable:Int = 1;
	
	public function new(t:TouchableBase) {
		super();
		
		touch = t;
		t.onClick << function() if (enabled) eClick.dispatch(mode);
		
		t.onDown << function() {
			enableOverDown();
			state = Press;
		}
		t.onUp << function() {
			disableOverDown();
			state = Focus;
		}
		t.onOver << function() state = Focus;
		t.onOut << function() state = Default;
		
		t.onOutUp << function() {
			disableOverDown();
			state = Default;
		}
		
		changeState << function(v) if (lowMode != 1) eVisual.dispatch(lowMode, v);
		
		changeLowMode << function(v) eVisual.dispatch(v, state);
		changeLowMode - 1 << disable;
		changeLowMode / 1 << enable;
		onEnable << function() lowMode = modeBeforeDisable;
		onDisable << function() {
			modeBeforeDisable = lowMode;
			lowMode = 1;
		}
		changeLowMode / 1 << function(v) mode = v > 1 ? v - 1 : v;
		changeBMode << function(v:Bool) {
			mode = v ? 1 : 0;
			if (!enabled) modeBeforeDisable = mode != 0 ? mode + 1 : mode;
		}
		allowChangeMode();
		onEnable << allowChangeMode;
		onDisable << disallowChangeMode;
	}

	public inline function sendVisual():Void eVisual.dispatch(mode, state);
	
	public function destroy():Void {
		touch.destroy();
		destroySignals();
	}
	
	private function allowChangeMode():Void changeMode << changeModeHandler;
	
	private function disallowChangeMode():Void changeMode >> changeModeHandler;
	
	private function changeModeHandler(v:Int):Void {
		lowMode = v != 0 ? v + 1 : v;
		bMode = v == 1;
	}
	
	@:extern inline private function enableOverDown():Void {
		touch.onOverDown << overDownHandler;
		touch.onOutDown << outDownHandler;
	}
	
	@:extern inline private function disableOverDown():Void {
		touch.onOverDown >> overDownHandler;
		touch.onOutDown >> outDownHandler;
	}
	
	private function overDownHandler():Void {
		eVisual.dispatch(lowMode, Press);
	}
	
	private function outDownHandler():Void {
		eVisual.dispatch(lowMode, Leave);
	}
	
	@:extern inline public function switchMap(a:Array<Int>):Void {
		onClick << function(v) mode = a[v];
	}
	
	@:extern inline public function bswitch():Void {
		onClick << function() bMode = !bMode;
	}
	
	public function join(b:ButtonCore):Void {
		b.changeLowMode << setLowMode;
		b.changeState << setState;
		b.onClick << click;
		changeMode << b.setLowMode;
		changeState << b.setState;
		onClick << b.click;
	}
	
	public function unjoin(b:ButtonCore):Void {
		b.changeLowMode >> setLowMode;
		b.changeState >> setState;
		b.onClick >> click;
		changeMode >> b.setLowMode;
		changeState >> b.setState;
		onClick >> b.click;
	}
	
	public function setLowMode(m:Int):Void lowMode = m;
	public function setState(s:ButtonState):Void state = s;
	public function click(mode:Int):Void eClick.dispatch(mode, true);

	inline public function reset():Void {
		lowMode = 0;
		state = Default;
	}
	
}