package pony.events;

@:forward(remove, signal)
abstract SignalController0(SignalControllerInner0) from SignalControllerInner0 {

	public function stop(): Void this.stop = true;

}