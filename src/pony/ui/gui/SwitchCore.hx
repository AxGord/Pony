package pony.ui.gui;

import pony.events.Signal2;
import pony.magic.HasSignal;

/**
 * SwitchCore
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class SwitchCore<T> implements HasSignal {

	@:auto public var onOpen: Signal2<T, UInt>;
	@:auto public var onClose: Signal2<T, UInt>;

	public var active(get, set): Int;
	private var _active: Int;
	private var objects: Array<T>;

	public function new(objects: Array<T>, def: Int = -1) {
		this.objects = objects;
		_active = def;
	}

	public inline function init(): Void {
		if (active != -1) eOpen.dispatch(objects[active], active);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_active(): Int return _active;

	public function set_active(id: Int): Int {
		if (id < 0) id = 0;
		else if (id >= objects.length) id = objects.length;
		if (active != id) {
			closeActive();
			_active = id;
			eOpen.dispatch(objects[active], active);
		}
		return id;
	}

	public inline function closeActive(): Void {
		if (active != -1) {
			eClose.dispatch(objects[active], active);
			_active = -1;
		}
	}

	public inline function open(obj: T): Void {
		closeActive();
		_active = objects.indexOf(obj);
		eOpen.dispatch(obj, active);
	}

}