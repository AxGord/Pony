package pony;

import pony.events.Signal0;
import pony.magic.HasSignal;

/**
 * Tumbler
 * @author AxGord <axgord@gmail.com>
 */
class Tumbler implements HasSignal {

	public var onEnable: Signal0;
	public var onDisable: Signal0;
	@:bindable public var enabled: Bool = true;

	public function new(enabled: Bool = true) {
		this.enabled = enabled;
		onEnable = changeEnabled - true;
		onDisable = changeEnabled - false;
	}

	public inline function enable(): Void enabled = true;

	public inline function disable(): Void enabled = false;

	public function sw(): Void enabled = !enabled;

	public inline function setEnabled(v: Bool): Void enabled = v;

}
