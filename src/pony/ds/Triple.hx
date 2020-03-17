package pony.ds;

typedef TripleImpl<A, B, C> = {
	a: A,
    b: B,
    c: C
}

/**
 * Triple
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) abstract Triple<A, B, C>(TripleImpl<A, B, C>) {

	public var a(get, set): A;
	public var b(get, set): B;
	public var c(get, set): C;

	public inline function new(a: A, b: B, c: C) this = { a: a, b: b, c: c };

	private inline function get_a(): A return this.a;
	private inline function get_b(): B return this.b;
	private inline function get_c(): C return this.c;

	private inline function set_a(v: A): A return this.a = v;
	private inline function set_b(v: B): B return this.b = v;
	private inline function set_c(v: C): C return this.c = v;

	@:from private static inline function fromObj<A, B, C>(o: TripleImpl<A, B, C>): Triple<A, B, C> return cast o;
	@:to public inline function toObj(): { a: A, b: B, c: C } return this;

	@:from private static inline function fromArray<T>(a: Array<T>): Triple<T, T, T> return new Triple(a[0], a[1], a[2]);

	public inline function toString(): String return 'a: $a; b: $b; c: $c';

}