package pony.events;
import pony.Priority.Priority;

/**
 * EventDispatcher
 * @author AxGord <axgord@gmail.com>
 */
class EventDispatcher {

	private var signals:Map<String, Signal>;
	
	public function new() {
		signals = new Map<String, Signal>();
	}
	
	public function dispatch(name:String, event:Event):Event {
		if (signals.exists(name))
			signals.get(name).dispatchEvent(event);
		return event;
	}
	
	public function addListener(name:String, l:Listener, p:Int=0):Void {
		if (!signals.exists(name))
			signals.set(name, new Signal(this));
		signals.get(name).add(l, p);
	}
	
	public function removeListener(name:String, l:Listener, p:Int=0):Void {
		if (signals.exists(name)) {
			var s:Signal = signals.get(name);
			s.remove(l);
			if (s.listenersCount == 0) signals.remove(name);
		}
	}
	
}