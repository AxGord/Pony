package pony.events;

/**
 * Signal0
 * @author AxGord <axgord@gmail.com>
 */
abstract Signal0<Target>(Signal) {
	public var silent(get,set):Bool;
	public var lostListeners(get, never):Signal0<Signal0<Target>>;
	public var takeListeners(get, never):Signal0<Signal0<Target>>;
	public var data(get, set):Dynamic;
	public var target(get, never):Target;
	public var listenersCount(get, never):Int;
	
	inline private function new(s:Signal) this = s;
	
	inline private function get_silent():Bool return this.silent;
	inline private function set_silent(b:Bool):Bool return this.silent = b;
	
	inline private function get_lostListeners():Signal0<Signal0<Target>> return cast this.lostListeners;
	inline private function get_takeListeners():Signal0<Signal0<Target>> return cast this.takeListeners;
	
	inline private function get_data():Dynamic return this.data;
	inline private function set_data(d:Dynamic):Dynamic return this.data = d;
	inline private function get_target():Target return this.target;
	inline private function get_listenersCount():Int return this.listenersCount;
	
	inline public function add(listener:Listener0<Target>, priority:Int = 0):Target {
		this.add(listener, priority);
		return target;
	}
	
	inline public function remove(listener:Listener0<Target>):Target {
		this.remove(listener);
		return target;
	}
	
	inline public function changePriority(listener:Listener0<Target>, priority:Int = 0):Target {
		this.changePriority(listener, priority);
		return target;
	}
	
	inline public function dispatch():Target {
		this.dispatchEmpty();
		return target;
	}
	
	inline public function dispatchEvent(event:Event):Target {
		this.dispatchEvent(event);
		return target;
	}
	
	inline public function dispatchArgs():Target {
		this.dispatchEmpty();
		return target;
	}
	
	inline public function dispatchEmpty(?_):Target {
		this.dispatchEmpty();
		return target;
	}
	
	@:from static private inline function from<A>(s:Signal):Signal0<A> return new Signal0<A>(s);
	
}