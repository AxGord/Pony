package pony.events;

/**
 * Signal1
 * @author AxGord <axgord@gmail.com>
 */
abstract Signal1<Target, T1>(Signal) {

	public var silent(get,set):Bool;
	public var lostListeners(get, never):Signal0<Signal1<Target, T1>>;
	public var takeListeners(get, never):Signal0<Signal1<Target, T1>>;
	public var data(get, set):Dynamic;
	public var target(get, never):Target;
	public var listenersCount(get, never):Int;
	
	inline private function new(s:Signal) this = s;
	
	inline private function get_silent():Bool return this.silent;
	inline private function set_silent(b:Bool):Bool return this.silent = b;
	
	inline private function get_lostListeners():Signal0<Signal1<Target, T1>> return cast this.lostListeners;
	inline private function get_takeListeners():Signal0<Signal1<Target, T1>> return cast this.takeListeners;
	
	inline private function get_data():Dynamic return this.data;
	inline private function set_data(d:Dynamic):Dynamic return this.data = d;
	inline private function get_target():Target return this.target;
	inline private function get_listenersCount():Int return this.listenersCount;
	
	inline public function add(listener:Listener1<Target, T1>, priority:Int = 0):Target {
		this.add(listener, priority);
		return target;
	}
	
	inline public function remove(listener:Listener1<Target, T1>):Target {
		this.remove(listener);
		return target;
	}
	
	inline public function changePriority(listener:Listener1<Target, T1>, priority:Int = 0):Target {
		this.changePriority(listener, priority);
		return target;
	}
	
	inline public function dispatch(a:T1):Target return dispatchArgs([a]);
	
	inline public function dispatchEvent(event:Event):Target {
		this.dispatchEvent(event);
		return target;
	}
	
	inline public function dispatchArgs(?args:Array<T1>):Target {
		this.dispatchArgs(args);
		return target;
	}
	
	inline public function dispatchEmpty(?_):Target {
		this.dispatchEmpty();
		return target;
	}
	
	inline public function sub(a:T1):Target return subArgs([a]);
	
	inline public function subArgs(args:Array<T1>):Target {
		this.subArgs(args);
		return target;
	}
	
	@:from static private inline function from<A,B>(s:Signal):Signal1<A,B> return new Signal1<A,B>(s);
	
}