package pony;
import pony.events.Listener;
import pony.events.Signal;
import pony.ui.ButtonCore;

/**
 * Tumbler
 * @author AxGord <axgord@gmail.com>
 */
class Tumbler {

	public var onEnable:Signal;
	public var onDisable:Signal;
	public var enabled(default, set):Bool = false;
	
	public function new() {
		onEnable = new Signal(this);
		onDisable = new Signal(this);
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