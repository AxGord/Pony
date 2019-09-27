package pony.events;

@:forward(remove, signal)
abstract SignalController2<T1, T2>(SignalControllerInner2<T1, T2>) from SignalControllerInner2<T1, T2> {

	public function stop(): Void this.stop = true;

}