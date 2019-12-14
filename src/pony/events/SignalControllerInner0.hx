package pony.events;

/**
 * SignalControllerInner0
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class SignalControllerInner0 {

	public var signal(default, null): Signal0;
	public var stop: Bool = false;
	@:nullSafety(Off) public var listener: Listener0;

	public inline function new(signal: Signal0) {
		this.signal = signal;
	}

	public inline function remove(): Void {
		signal.remove(listener);
	}

	public inline function destroy(): Void {
		@:nullSafety(Off) {
			signal = null;
			listener = null;
		}
	}

}