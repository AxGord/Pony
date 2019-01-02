package pony;

/**
 * Tasks
 * @author AxGord <axgord@gmail.com>
 */
abstract Tasks(Pair<Int, Void -> Void>) {
	
	public var ready(get, never):Bool;
	public inline function new(cb:Void -> Void) this = new Pair(0, cb);
	public function add():Void this.a++;
	public function end():Void if (--this.a == 0) this.b();
	@:extern private inline function get_ready():Bool return this.a == 0;
	
}