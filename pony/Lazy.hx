package pony;

/**
 * Lazy
 * @author AxGord <axgord@gmail.com>
 */
abstract Lazy<T>(Void -> T) {
	
	inline public function new(f:Void -> T) this = f;
	
	@:from inline static public function fromT<V>(v:V):Lazy<V> return new Lazy<V>(function():V return v);
	
	@:from inline static public function fromF<V>(f:Void->V):Lazy<V> return new Lazy<V>(f);
	
	@:to inline public function toT():T {
		var v:T = this();
		this = fromT(v);
		return v;
	}
	
	@:to inline public function toF():Void->T return this;
}