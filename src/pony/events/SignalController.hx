package pony.events;

/**
 * SignalController
 * @author AxGord <axgord@gmail.com>
 */
@:forward(remove)
abstract SignalController({ stop: Bool, remove: Void -> Void }) {

	public inline function stop(): Void this.stop = true;

}
