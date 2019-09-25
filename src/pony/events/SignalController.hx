package pony.events;

import pony.events.SignalController2;

@:forward(stop, remove)
abstract SignalController({stop: Void -> Void, remove: Void -> Void}) from SignalController2<Any, Any> {}