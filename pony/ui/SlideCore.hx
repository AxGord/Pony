package pony.ui;
import pony.DeltaTime;
import pony.events.Signal;

/**
 * ...
 * @author AxGord
 */
class SlideCore {
	
	public var total:Float;
	public var current:Float;
	public var speed:Float;
	public var minimalMove:Float = 0.1;
	public var update(default, null):Signal;
	
	public var opened(default, null):Bool;
	public var closed(default, null):Bool;
	
	public var onOpen(default, null):Signal;
	public var onClose(default, null):Signal;
	
	public function new(total:Float=1, speed:Float=30) {
		this.total = total;
		this.speed = speed;
		current = 0;
		opened = false;
		closed = true;
		update = new Signal();
		onOpen = new Signal();
		onClose = new Signal();
	}
	
	public function open(?to:Float):Void {
		if (to != null) total = to;
		if (opened) return;
		if (!closed) DeltaTime.update.remove(closing);
		closed = false;
		DeltaTime.update.add(opening);
	}
	
	public function close():Void {
		if (closed) return;
		if (!opened) DeltaTime.update.remove(opening);
		opened = false;
		DeltaTime.update.add(closing);
	}
	
	private function opening(dt:Float):Void {
		current += (total * minimalMove + current) * dt * speed;
		if (current >= total) {
			current = total;
			opened = true;
			DeltaTime.update.remove(opening);
			onOpen.dispatch();
		}
		update.dispatch(current, opened, closed);
	}
	
	
	private function closing(dt:Float):Void {
		current -= (total * minimalMove + (total - current)) * dt * speed;
		if (current <= 0) {
			current = 0;
			closed = true;
			DeltaTime.update.remove(closing);
			onClose.dispatch();
		}
		update.dispatch(current, opened, closed);
	}
	
	
}