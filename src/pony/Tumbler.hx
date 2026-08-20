package pony;

import pony.events.Signal0;
import pony.magic.HasSignal;

/**
 * Tumbler
 * @author AxGord <axgord@gmail.com>
 */
class Tumbler implements HasSignal {

	@:bindable public var enabled: Bool = true;
	public var onEnable: Signal0;
	public var onDisable: Signal0;

	public function new(enabled: Bool = true) {
		this.enabled = enabled;
		onEnable = changeEnabled - true;
		onDisable = changeEnabled - false;
	}

	public inline function enable(): Void enabled = true;

	public inline function disable(): Void enabled = false;

	public inline function setEnabled(v: Bool): Void enabled = v;

	public function sw(): Void enabled = !enabled;

}
