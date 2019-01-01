package pony;

/**
 * Pair
 * @author AxGord <axgord@gmail.com>
 */
abstract Pair<A, B>({a:A, b:B}) {

	public var a(get, set):A;
	public var b(get, set):B;
	
	inline public function new(a:A, b:B) this = { a:a, b:b };
	
	inline private function get_a():A return this.a;
	inline private function get_b():B return this.b;
	
	inline private function set_a(v:A):A return this.a = v;
	inline private function set_b(v:B):B return this.b = v;
	
	@:from inline private static function fromObj<A,B>(o: { a:A, b:B } ):Pair<A,B> return cast o;
	@:to inline public function toObj(): { a:A, b:B } return this;
	
	@:from inline private static function array<T>(a:Array<T>):Pair<T,T> return new Pair(a[0],a[1]);

	public inline function toString():String return 'a: $a; b: $b';

}