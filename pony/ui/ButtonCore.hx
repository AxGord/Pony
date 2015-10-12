package pony.ui;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.touchManager.TouchebleBase;

enum ButtonState {
	Default; Focus; Leave; Press;
}

/**
 * ButtonCore
 * @author AxGord <axgord@gmail.com>
 */
class ButtonCore extends Tumbler implements HasSignal {

	@:auto public var onVisual:Signal2<Int, ButtonState>;
	@:bindable public var lowMode:Int = 0;
	@:bindable public var mode:Int = 0;
	@:bindable public var bMode:Bool = false;
	public var touch:TouchebleBase;
	@:auto public var onClick:Signal1<Int>;
	@:bindable public var state:ButtonState = Default;
	
	
	private var modeBeforeDisable:Int = 1;
	
	public function new(t:TouchebleBase) {
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
		
		changeLowMode << function(v) eVisual.dispatch(v,state);
		changeLowMode - 1 << disable;
		changeLowMode / 1 << enable;
		onEnable << function() lowMode = modeBeforeDisable;
		onDisable << function() {
			modeBeforeDisable = lowMode;
			lowMode = 1;
		}
		changeLowMode / 1 << function(v) mode = v > 1 ? v - 1 : v;
		changeMode << function(v) lowMode = v != 0 ? v + 1 : v;
		changeMode << function(v) bMode = v == 1;
		changeBMode << function(v) mode = v ? 1 : 0;
		
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
	
}