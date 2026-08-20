package pony;

import pony.Tools;

/**
 * TimeMachine
 * @author AxGord <axgord@gmail.com>
 */
class TimeMachine<T> {

	public var state(default, null): T;

	public var canUndo(get, never): Bool;

	private final defaultState: T;

	private var states: Array<T> = [];

	public function new(def: T) {
		defaultState = def;
		reset();
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_canUndo(): Bool return states.length > 0;

	public dynamic function copy(o: T): T return Tools.clone(o);

	public function reset(): Void {
		state = copy(defaultState);
		onState();
	}

	public function fullReset(): Void {
		final l: Bool = states.length > 0;
		states = [];
		reset();
		if (l) onNotCanUndo();
	}

	public dynamic function onCanUndo(): Void {}

	public dynamic function onNotCanUndo(): Void {}

	public dynamic function onState(): Void {}

	public function push(): Void {
		states.push(copy(state));
		if (states.length == 1) onCanUndo();
	}

	public function undo(): Void {
		if (states.length == 0) return;
		state = states.pop();
		onState();
		if (states.length == 0) onNotCanUndo();
	}

	public function clear(): Void {
		push();
		reset();
	}

}
