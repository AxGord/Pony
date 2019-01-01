package pony;

/**
 * KeyValue
 * @author AxGord <axgord@gmail.com>
 */
abstract KeyValue<Key, Value>(Pair<Key, Value>) {

	public var key(get, never):Key;
	public var value(get, never):Value;
	
	inline public function new(p:Pair<Key, Value>) this = p;
	inline private function get_key():Key return this.a;
	inline private function get_value():Value return this.b;
	
	@:from inline static private function fromPair<A, B>(p:Pair<A, B>):KeyValue<A, B> return new KeyValue<A, B>(p);
	@:to inline private function toPair():Pair<Key, Value> return this;
	
}