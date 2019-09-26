package pony.events;

class SignalControllerInner1<T1> {
	
	public var signal(default, null): Signal1<T1>;
	public var stop: Bool = false;
	public var listener: Listener1<T1>;

	public inline function new(signal: Signal1<T1>) {
		this.signal = signal;
	}

	public inline function remove(): Void {
		signal.remove(listener);
	}

	public inline function destroy(): Void {
		signal = null;
		listener = null;
	}

}