package pony.events;

/**
 * Listener0
 * @author AxGord <axgord@gmail.com>
 */
abstract Listener0<Target>(Listener) {
	inline private function new(l:Listener) this = l;
	@:from inline private static function from0(f:Void->Void):Listener0<Target> return new Listener0(f);
	@:from inline private static function fromEvent(f:Event->Void):Listener0<Target> return new Listener0(f);
	@:to inline private function to():Listener return this;
}