package pony.ds;

/**
 * KeyValue
 * @author AxGord <axgord@gmail.com>
 */
abstract KeyValue<Key, Value>(Pair<Key, Value>) {

	public var key(get, never):Key;
	public var value(get, never):Value;

	public inline function new(p: Pair<Key, Value>) this = p;
	private inline function get_key(): Key return this.a;
	private inline function get_value(): Value return this.b;

	@:from private static inline function fromPair<A, B>(p: Pair<A, B>): KeyValue<A, B> return new KeyValue<A, B>(p);
	@:to private inline function toPair(): Pair<Key, Value> return this;

}