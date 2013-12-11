package pony.events;

/**
 * SignalTar
 * @author AxGord <axgord@gmail.com>
 */
abstract SignalTar<T>(Signal) {
	inline public function new(s:Signal) this = s;
	@:to inline private function to0():Signal0<T> return this;
	@:to inline private function to1<A>():Signal1<T,A> return this;
}