package pony;

import pony.Tools;

/**
 * TimeMachine
 * @author AxGord <axgord@gmail.com>
 */
class TimeMachine<T> {

	public var state(default, null):T;
	public var canUndo(get, never):Bool;
	private var states:Array<T> = [];
	private var defaultState:T;
	
	public function new(def:T) {
		defaultState = def;
		reset();
	}
	
	dynamic public function copy(o:T):T return Tools.clone(o);
	
	public function reset():Void {
		state = copy(defaultState);
		onState();
	}
	
	public function fullReset():Void {
		var l = states.length > 0;
		states = [];
		reset();
		if (l) onNotCanUndo();
	}
	
	public dynamic function onCanUndo():Void {}
	public dynamic function onNotCanUndo():Void {}
	public dynamic function onState():Void {}
	
	@:extern inline private function get_canUndo():Bool return states.length > 0;
	
	public function push():Void {
		states.push(copy(state));
		if (states.length == 1) onCanUndo();
	}
	
	public function undo():Void {
		if (states.length == 0) return;
		state = states.pop();
		onState();
		if (states.length == 0) onNotCanUndo();
	}
	
	public function clear():Void {
		push();
		reset();
	}
	
}