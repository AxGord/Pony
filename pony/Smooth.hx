package pony;
import pony.events.Signal;

/**
 * Smooth
 * @author AxGord <axgord@gmail.com>
 */
class Smooth<T> {

	public var update:Signal;
	private var vals:Array<T>;
	
	public function new() {
		vals = [];
		update = new Signal();
		DeltaTime.update.
	}
	
	public function set(v:T):Void {
		vals.push(v);
	}
	
	
	
}