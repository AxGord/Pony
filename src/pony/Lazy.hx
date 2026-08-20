package pony;

/**
 * Lazy
 * @author AxGord <axgord@gmail.com>
 */
abstract Lazy<T>(Void -> T) {

	public inline function new(f: Void -> T) this = f;

	@:to public inline function toT(): T {
		final v: T = this();
		this = fromT(v);
		return v;
	}

	@:to public inline function toF(): Void -> T return this;

	@:from public static inline function fromT<V>(v: V): Lazy<V> return new Lazy<V>(function(): V return v);

	@:from public static inline function fromF<V>(f: Void -> V): Lazy<V> return new Lazy<V>(f);

}
