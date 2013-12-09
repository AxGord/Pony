package pony;
import pony.events.Signal;
import pony.events.Listener;
import pony.ui.ButtonCore;
/**
 * TTumbler
 * @author AxGord <axgord@gmail.com>
 */
interface TTumbler extends traits.ITrait {
	public var onEnable:Signal;
	public var onDisable:Signal;
	public var enabled(default, set):Bool = false;
	
	private function tumblerInit(defaultState:Bool=false):Void {
		onEnable = new Signal(this);
		onDisable = new Signal(this);
		enabled = defaultState;
	}
	
	public function set_enabled(v:Bool):Bool {
		if (v == enabled) return v;
		enabled = v;
		if (v) onEnable.dispatch();
		else onDisable.dispatch();
		return v;
	}
	
	public function regDT(l:Listener, priority:Int = 0):Void {
		onEnable.add(DeltaTime.update.add.bind(l, priority));
		onDisable.add(DeltaTime.update.remove.bind(l));
	}
	
	public function regButton(b:ButtonCore):Void {
		b.sw = [2, 1, 0];
		if ((enabled && b.mode == 0) || (!enabled && b.mode == 2)) {
			b.onMode.add(function(mode:Int) enabled = mode == 0);
			onEnable.add(function() b.mode = 0);
			onDisable.add(function() b.mode = 2);
		} else {
			b.onMode.add(function(mode:Int) enabled = mode == 2);
			onEnable.add(function() b.mode = 2);
			onDisable.add(function() b.mode = 0);
		}
	}
	
}