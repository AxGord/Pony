package pony.events;

/**
 * SignalController2
 * @author AxGord <axgord@gmail.com>
 */
@:forward(remove, signal)
abstract SignalController2<T1, T2>(SignalControllerInner2<T1, T2>) from SignalControllerInner2<T1, T2> {

	public function stop(): Void this.stop = true;

}