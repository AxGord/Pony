package pony.events;

/**
 * Listener1
 * @author AxGord <axgord@gmail.com>
 */
abstract Listener1<Target, T1>(Listener) {
	inline private function new(l:Listener) this = l;
	@:from inline private static function from0<T,A>(f:Void->Void):Listener1<T, A> return new Listener1(f);
	@:from inline private static function fromEvent<T,A>(f:Event->Void):Listener1<T, A> return new Listener1(f);
	@:from inline private static function from1<T,A>(f:A->Void):Listener1<T,A> return new Listener1(f);
	@:from inline private static function from1Tar<T,A>(f:A->T->Void):Listener1<T,A> return new Listener1(f);
	@:to inline private function to():Listener return this;
}