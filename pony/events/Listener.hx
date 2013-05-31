package pony.events;

import pony.Dictionary;

using Lambda;

/**
 * ...
 * @author AxGord
 */

typedef Listener_ = { f:Function, count:Int, event:Bool, prev:Event, used:Int }
 
abstract Listener( Listener_ ) {
	
	public static var flist:Map<Int, Listener> = new Map<Int, Listener>();
	//public static var eflist:Dictionary<Event->Void, Listener> = new Dictionary<Event->Void, Listener>();
	
	inline public function new(f:Function, event:Bool = false, count:Int = -1) {
		f._use();
		this = {f:f, count:count, event:event, prev: null, used: 0}
	}
	
	@:from inline static public function fromEFunction(f:Event->Void):Listener
		return _fromFunction(f, true);
	
	@:from inline static public function fromFunction(f:Function):Listener
		return _fromFunction(f, false);
	
	static public function _fromFunction(f:Function, ev:Bool):Listener {
		if (flist.exists(f.id())) {
			return flist.get(f.id());
		} else {
			//trace(ev);
			var o:Listener = new Listener(f, ev);
			flist.set(f.id(), o);
			return o;
		}
    }
	
	inline public function count():Int return this.count;
	
	public function call(event:Event):Bool {
		this.count--;
		event._setListener(this);
		var r:Dynamic = null;
		if (this.event)
			r = this.f._call([event]);
		else
			r = this.f._call(event.args.slice(0, this.f.count()));
		this.prev = event;
		return r == null ? true : r;
	}
	
	inline public function setCount(count:Int):Listener {
		return new Listener(this.f, this.event,  count);
	}
	
	inline public function _use():Void {
		this.used++;
	}
	
	inline public function unuse():Void {
		this.used--;
		if (this.used <= 0) {
			//if (this.event) {
			//	eflist.remove(this.f.get());
			//} else {
				flist.remove(this.f.id());
			//}
			this.f.unuse();
			this = null;
		}
	}
	
	inline public function used():Int return this.used;
	
	static public function unusedCount():Int {
		var c:Int = 0;
		for (l in flist) if (l.used() <= 0) c++;
		//for (l in eflist) if (l.used() <= 0) c++;
		return c;
	}
	
}
