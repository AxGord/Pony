package pony;

/**
 * Typed object pool
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 3.30)
@:generic class TypedPool<T: haxe.Constraints.Constructible<Void -> Void>> implements IPool<T> {
#else
@:generic class TypedPool<T: { function new(): Void; }> implements IPool<T> {
#end
	public var list: Array<T> = [];
	public var isDestroy(get, never): Bool;

	public inline function new() {}

	#if (!flash && !debug)
	inline
	#end
	public function get(): T {
		var v: Null<T> = list.pop();
		return v == null ? new T() : v;
	}

	#if !flash
	inline
	#end
	public function ret(obj: T): Void list.push(untyped obj);

	#if !flash
	inline
	#end
	public function destroy(): Void {
		list = null;
	}

	@:extern public inline function get_isDestroy(): Bool return list == null;

}

/**
 * Typed object pool with arg
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 3.30)
@:generic class TypedPool1<T: haxe.Constraints.Constructible<A1 -> Void>, A1> {
#else
@:generic class TypedPool1<T: { function new(a1: A1): Void; }, A1> {
#end
	public var list: Array<T> = [];
	public var isDestroy(get, never): Bool;
	private var a1: A1;

	public inline function new(a1: A1) {
		this.a1 = a1;
	}

	#if (!flash && !debug)
	inline
	#end
	public function get(): T {
		var v: Null<T> = list.pop();
		return v == null ? new T(a1) : v;
	}

	#if !flash
	inline
	#end
	public function ret(obj: T): Void list.push(untyped obj);

	#if !flash
	inline
	#end
	public function destroy(): Void {
		list = null;
		a1 = null;
	}

	@:extern public inline function get_isDestroy(): Bool return list == null;

}

/**
 * Typed object pool with two args
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 3.30)
@:generic class TypedPool2<T: haxe.Constraints.Constructible<A1 -> A2 -> Void>, A1, A2> {
#else
@:generic class TypedPool2<T: {function new(a1: A1, a: A2): Void; }, A1, A2> {
#end
	public var list: Array<T> = [];
	public var isDestroy(get, never): Bool;
	private var a1: A1;
	private var a2: A2;

	public inline function new(a1: A1, a2: A2) {
		this.a1 = a1;
		this.a2 = a2;
	}

	#if (!flash && !debug)
	inline
	#end
	public function get(): T {
		var v: Null<T> = list.pop();
		return v == null ? new T(a1, a2) : v;
	}

	#if !flash
	inline
	#end
	public function ret(obj: T): Void list.push(untyped obj);

	#if !flash
	inline
	#end
	public function destroy(): Void {
		list = null;
		a1 = null;
		a2 = null;
	}

	@:extern public inline function get_isDestroy(): Bool return list == null;

}