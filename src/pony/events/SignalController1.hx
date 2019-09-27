package pony.events;

/**
 * SignalController1
 * @author AxGord <axgord@gmail.com>
 */
@:forward(remove, signal)
abstract SignalController1<T1>(SignalControllerInner1<T1>) from SignalControllerInner1<T1> {

	public function stop(): Void this.stop = true;

}