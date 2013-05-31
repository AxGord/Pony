package pony.events;

/**
 * ...
 * @author AxGord
 */
class LV<T> extends Signal {

	public var value(default, set):T;
	
	public inline function new(value:T) {
		super();
		this.value = value;
	}
	
	public inline function set_value(v:T):T {
		if (v == value) return v;
		value = v;
		dispatchArgs([v]);
		return v;
	}
	
}