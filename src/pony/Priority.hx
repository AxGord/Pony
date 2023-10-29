package pony;

import pony.events.Signal0;
import pony.magic.HasSignal;

using Lambda;

typedef PriorityIds = Priority<{
	id: Int,
	name: String
}>;

/**
 * Priority
 * todo: get element priority
 * @author AxGord
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:nullSafety(Strict) @:final class Priority<T:Dynamic> implements HasSignal {

	#if (!macro)
	@:lazy public var onTake: Signal0;
	@:lazy public var onLost: Signal0;
	#end

	/**
	 * Total elements count.
	 */
	public var length(get, never): Int;

	/**
	 * Lowest priority number.
	 */
	public var min(get, never): Int;

	/**
	 * Hightest priority number.
	 */
	public var max(get, never): Int;

	/**
	 * First element.
	 */
	public var first(get, never): T;

	/**
	 * Last element.
	 */
	public var last(get, never): T;

	/**
	 * True if priority list not have element and false if have.
	 */
	#if pony_experimental
	@:bindable public var empty: Bool = true;
	#else
	public var empty(default, null): Bool = true;
	#end

	/**
	 * if true: [[1, 1, 3]] - normal. Default false.
	 */
	public var double: Bool;

	/**
	 * Current element in loop.
	 */
	public var current(get, never): T;

	public var data(default, null): Array<T> = [];

	private var hash: Map<Int, Int> = new Map<Int, Int>();

	private var addStack: Array<Pair<T, Int>> = [];

	public var lock(default, set): Bool = false;

	/**
	 * Counters for loops
	 */
	public var counters(default, null): Array<Int> = [0];

	public function new(?data: Array<T>, dbl: Bool = false) {
		double = dbl;
		if (data != null) {
			this.data = data;
			if (data.length > 0) empty = false;
			repriority();
		}
	}

	public inline function map(f: T -> T): Void data = data.map(f);

	public dynamic function real(e: T): Bool return true;

	public function changeReals(): Void {
		var empt: Bool = checkEmpty();
		if (empt != empty) {
			empty = empt;
			#if (!macro)
			if (empt)
				eLost.dispatch();
			else
				eTake.dispatch();
			#end
		}
	}

	private function checkEmpty(): Bool {
		for (e in data) if (real(e)) return false;
		return true;
	}

	/**
	 * Add element in priority list with custom priority.
	 * @param	element elements for adding.
	 * @param	priority priority, smalest first, bigest last, default 0 (0 - normal priority).
	 */
	public function add(e: T, priority: Int = 0): Priority<T> {
		if (!double && exists(e))
			return this;
		if (lock) {
			addStack.push(new Pair(e, priority));
			return this;
		}
		var needOnTake: Bool = real(e) && empty;
		var hv: Null<Int> = hash.get(priority);
		var s: Int = hv != null ? hv : 0;
		var c: Int = 0;
		for (k in hash.keys()) if (k < priority) @:nullSafety(Off) c += hash.get(k);
		c += s;
		data.insert(c, e);
		for (k in 0...counters.length) if (c < counters[k]) counters[k]++;
		hash.set(priority, s + 1);
		if (needOnTake) {
			empty = false;
			#if (!macro)
			eTake.dispatch();
			#end
		}
		return this;
	}

	private function set_lock(v: Bool): Bool {
		if (data == null) return v;
		if (lock != v) {
			lock = v;
			if (!v) {
				for (e in addStack) add(e.a, e.b);
				addStack = [];
			}
		}
		return v;
	}

	/**
	 * Add elements array in priority list with custom priority.
	 * @param	a elements array for adding.
	 * @param	priority priority, smalest first, bigest last, default 0 (0 - normal priority).
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function addArray(a: Array<T>, priority: Int = 0): Priority<T> {
		for (e in a) add(e, priority);
		return this;
	}

	/**
	 * Example: [
	 * var sum:Int = 0;
	 * for (e in p)
	 * 	sum += e;
	 * sum; //145 ]
	 * Elements begining with lowest priority, ending higtest.<br/>
	 * This funcion not crashed if you make operations with Priority object. You can remove and add elements in "for" body.
	 */
	public function iterator(): Iterator<T> {
		var n: Int = counters.push(0) - 1;
		var i: Int = 0;
		return {
			hasNext: function(): Bool {
				if (counters == null) return false; // if destroy in iteration
				if (counters.length < n) counters.push(i);
				if (data.length > counters[n]) {
					return true;
				} else {
					counters.splice(n, 1);
					return false;
				}
			},
			next: function(): T return data[counters[n]++]
		};
	}

	/**
	 * Call this method if you use break
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function brk(): Void if (counters != null) counters.splice(1, counters.length);

	/**
	 * Remove all elements
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function clear(): Priority<T> {
		var needOnLost: Bool = !empty;
		_clear();
		if (needOnLost) {
			empty = true;
			#if (!macro)
			eLost.dispatch();
			#end
		}
		return this;
	}

	/**
	 * Remove all elements
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function _clear(): Priority<T> {
		hash = new Map<Int, Int>();
		data = [];
		counters = [0];
		addStack = [];
		return this;
	}

	/**
	 * Destroy this object
	 */
	public function destroy(): Void {
		if (hash == null) return;
		clear();
		@:nullSafety(Off) hash = null;
		@:nullSafety(Off) data = null;
		@:nullSafety(Off) counters = null;
		@:nullSafety(Off) addStack = null;
		#if (!macro)
		destroySignals();
		#end
	}

	/**
	 * Set this function for custom compare priority elements
	 * @param	a
	 * @param	b
	 */
	public dynamic function compare(a: T, b: T): Bool return a == b;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function exists(element: T): Bool return existsFunction(compare.bind(element));

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function existsFunction(f: T -> Bool): Bool return data.exists(f);

	public function existsArray(a: Array<T>): Bool {
		for (e in a) if (exists(e)) return true;
		return false;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function indexOfFunction(f: T -> Bool): Int return pony.Tools.ArrayTools.fIndexOf(data, f);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function indexOfElement(element: T): Int return indexOfFunction(compare.bind(element));

	/**
	 * Some time need take object with custom value.
	 */
	public function search(f: T -> Bool): Null<T> {
		var s: Null<T> = null;
		existsFunction(function(e: T): Bool {
			if (f(e)) {
				s = e;
				return true;
			} else {
				return false;
			}
		});
		return s;
	}

	/**
	 * @param	e Element
	 */
	public function getPriority(e: T): Null<Int> {
		var a: Array<Int> = [for (k in hash.keys()) k];
		a.sort(asort);
		var i: Int = 0;
		for (k in a) {
			@:nullSafety(Off) var j: Int = hash[k];
			for (n in i...(i + j)) if (compare(data[n], e)) return k;
			i += j;
		}
		return null;
	}

	private function asort(x: Int, y: Int): Int return x - y;

	/**
	 * @param	e Element for removing
	 */
	public function remove(e: T): Bool {
		if (lock) {
			var ns: Array<Pair<T, Int>> = [];
			for (st in addStack) if (!compare(st.a, e)) ns.push(st);
			addStack = ns;
		}

		var i: Int = indexOfElement(e);
		if (i == -1) return false;
		var needOnLost: Bool = real(e) && !empty;
		for (k in 0...counters.length) if (i < counters[k]) counters[k]--;

		data.splice(i, 1);

		var a: Array<Int> = [for (k in hash.keys()) k];
		a.sort(asort);
		for (k in a) {
			@:nullSafety(Off) var n: Int = hash.get(k);
			if (i > 0) {
				i -= n;
			} else {
				if (n > 1)
					hash.set(k, n - 1);
				else
					hash.remove(k);
				break;
			}
		}
		if (needOnLost && checkEmpty()) {
			empty = true;
			#if (!macro)
			eLost.dispatch();
			#end
		}
		if (double) remove(e);
		return true;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function removeFunction(f: T -> Bool): Bool {
		var e: Null<T> = search(f);
		return if (e != null) remove(e); else false;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function removeArray(a: Array<T>): Bool {
		var f: Bool = true;
		for (e in a) if (!remove(e)) f = false;
		return f;
	}

	/**
	 * All elements taking new priority, but save order.
	 * @param	priority New priority, default 0
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function repriority(priority: Int = 0): Void {
		hash = new Map<Int, Int>();
		hash.set(priority, data.length);
	}

	/**
	 * todo: optimize
	 */
	public function change(e: T, priority: Int = 0): Priority<T> {
		if (remove(e))
			add(e, priority);
		else
			throw 'Element not exists';
		return this;
	}

	public function changeFunction(f: T -> Bool, priority: Int = 0): Priority<T> {
		var e: Null<T> = search(f);
		return e == null ? this : change(e, priority);
	}

	public function changeArray(a: Array<T>, priority: Int = 0): Priority<T> {
		for (e in a) change(e, priority);
		return this;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function toString(): String return data.toString();

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function join(sep: String): String return data.join(sep);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_first(): T return data[0];

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_last(): T return data[data.length - 1];

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_length(): Int return data.length;

	/**
	 * Make infinity loop. This good method for devolopment UI.
	 * @return Next element in loop.
	 */
	public function loop(): Null<T> {
		if (counters[0] >= length) {
			counters[0] = 0;
			if (empty) return null;
		}
		return data[counters[0]++];
	}

	/**
	 * Next time loop return first element.
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function resetLoop(): Priority<T> {
		counters[0] = 0;
		return this;
	}

	/**
	 * Start loop from custom element.
	 * Use exists() before call this function for safely run.
	 * @param	e first element for loop.
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function reloop(e: T): Void while (loop() != e) null;

	/**
	 * @return Current element in loop.
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_current(): T {
		return if (counters[0] > length) data[0] else if (counters[0] < 1) data[length - 1] else data[counters[0] - 1];
	}

	/**
	 * Make infinity loop. This good method for devolopment UI.
	 * @return Previos element in loop.
	 */
	public function backLoop(): Null<T> {
		if (empty) {
			counters[0] = 0;
			return null;
		}
		counters[0]--;
		if (counters[0] < 1)
			counters[0] = length;
		return data[counters[0] - 1];
	}

	/**
	 * Get minimal index.
	 */
	private function get_min(): Int {
		var n: Null<Int> = null;
		for (k in hash.keys())
			if (n == null || k < n)
				n = k;
		return n;
	}

	/**
	 * Get maximal index.
	 */
	private function get_max(): Int {
		var n: Null<Int> = null;
		for (k in hash.keys())
			if (n == null || k > n)
				n = k;
		return n;
	}

	/**
	 * Add element with lowest priority.
	 * @param	o T or Array&lt;T&gt;.
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function addToBegin(e: T): Void add(e, min - 1);

	/**
	 * Add element with hightest priority.
	 * @param	o T or Array&lt;T&gt;.
	 */
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function addToEnd(e: T): Void add(e, max + 1);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function isDestroy(): Bool return data == null;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function createIds(a: Array<String>): PriorityIds {
		var i: Int = 0;
		return new Priority([for (e in a) {id: i++, name: e}]);
	}

}