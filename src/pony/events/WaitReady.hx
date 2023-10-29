package pony.events;

/**
 * WaitReady Helper
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
abstract WaitReady(Null<Array<Void -> Void>>) {

	public var isReady(get, never): Bool;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function new() this = [];

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function ready(): Void {
		if (this != null) {
			var l: Array<Void -> Void> = this;
			this = null;
			for (f in l) f();
		}
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function get_isReady(): Bool return this == null;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function wait(cb: Void -> Void): Void isReady ? cb() : this.push(cb);

}