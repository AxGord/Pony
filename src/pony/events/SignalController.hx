package pony.events;

import pony.events.SignalController2;

@:forward(remove)
abstract SignalController({stop: Bool, remove: Void -> Void}) {

	public inline function stop(): Void this.stop = true;

}