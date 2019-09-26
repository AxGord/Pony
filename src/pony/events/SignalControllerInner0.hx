package pony.events;

class SignalControllerInner0 {
	
	public var signal(default, null): Signal0;
	public var stop: Bool = false;
	public var listener: Listener0;

	public inline function new(signal: Signal0) {
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