package pony;

typedef PairImpl<A, B> = {
	a: A,
	b: B
}

/**
 * Pair
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) abstract Pair<A, B>(PairImpl<A, B>) {

	public var a(get, set): A;
	public var b(get, set): B;

	public inline function new(a: A, b: B) this = { a: a, b: b };

	private inline function get_a(): A return this.a;
	private inline function get_b(): B return this.b;

	private inline function set_a(v: A): A return this.a = v;
	private inline function set_b(v: B): B return this.b = v;

	@:from private static inline function fromObj<A, B>(o: PairImpl<A, B>): Pair<A, B> return cast o;
	@:to public inline function toObj(): { a: A, b: B } return this;

	@:from private static inline function fromArray<T>(a: Array<T>): Pair<T, T> return new Pair(a[0], a[1]);

	public inline function toString(): String return 'a: $a; b: $b';

}