/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony;

using Lambda;

typedef PriorityIds = Priority<{id:Int,name:String}>;

/**
 * todo: get element priority
 * @author AxGord
 */
class Priority<T:Dynamic> {
	
	/**
	 * Total elements count.
	 */
	public var length(get, never):Int;
	
	/**
	 * Lowest priority number.
	 */
	public var min(get, never):Int;
	
	/**
	 * Hightest priority number.
	 */
	public var max(get, never):Int;
	
	/**
	 * First element.
	 */
	public var first(get, never):T;
	
	/**
	 * Last element.
	 */
	public var last(get, never):T;
	
	/**
	 * is empty
	 */
	public var empty(get, never):Bool;
	
	/**
	 * if true: [[1, 1, 3]] - normal. Default false.
	 */
	public var double:Bool = false;
	
	/**
	 * Current element in loop.
	 */
	public var current(get, never):T;
	
	public var data(default,null):Array<T>;
	
	private var hash:Map<Int, Int>;
	private var counters:Array<Int>;

	public function new(?data:Array<T>) {
		clear();
		if (data != null) {
			for (e in data) addElement(e);
			//Not work?
			//this.data = data;
		}
	}
	
	/**
	 * Add element in priority list with custom priority.
	 * @param	element elements for adding.
	 * @param	priority priority, smalest first, bigest last, default 0 (0 - normal priority).
	 */
	public function addElement(e:T, priority:Int = 0):Priority<T> {
		if (!double && existsElement(e)) return this;
		var s:Int = hash.exists(priority) ? hash.get(priority) : 0;
		var c:Int = 0;
		for (k in hash.keys())
			if (k < priority) c += hash.get(k);
		c += s;
		data.insert(c, e);
		for (k in 0...counters.length)
			if (c < counters[k]) counters[k]++;
		hash.set(priority, s + 1);
		return this;
	}
	
	/**
	 * Add elements array in priority list with custom priority.
	 * @param	a elements array for adding.
	 * @param	priority priority, smalest first, bigest last, default 0 (0 - normal priority).
	 */
	inline public function addArray(a:Array<T>, priority:Int = 0):Priority<T> {
		for (e in a)
			addElement(e, priority);
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
	public function iterator():Iterator<T> {
		var n:Int = counters.push(0) - 1;
		return {
			hasNext: function():Bool {
				if (counters.length < n) counters.push(n);
				if (data[counters[n]] != null)
					return true;
				else {
					counters.splice(n, 1);
					return false;
				}
			},
			next: function():T return data[counters[n]++]
		};
	}
	
	/**
	 * Remove all elements
	 */
	public function clear():Priority<T> {
		hash = new Map<Int,Int>();
		data = [];
		counters = [0];
		return this;
	}
	
	public function destroy():Void {
		hash = null;
		data = null;
		counters = null;
	}
	
	/**
	 * Set this function for custom compare priority elements
	 * @param	a
	 * @param	b
	 */
	dynamic public function compare(a:T, b:T):Bool return a == b;
	
	public inline function existsElement(element:T):Bool return existsFunction(compare.bind(element));
	
	public inline function existsFunction(f:T->Bool):Bool return data.exists(f);
	
	public function existsArray(a:Array<T>):Bool {
		for (e in a) if (existsElement(e)) return true;
		return false;
	}
	
	/**
	 * Some time need take object with custom value.
	 */
	public function search(f:T->Bool):T {
		var s:T = null;
		existsFunction(function(e:T):Bool {
			if (f(e)) {
				s = e;
				return true;
			} else
				return false;
		});
		return s;
	}

	/**
	 * @param	e Element
	 */
	public function getElementPriority(e:T):Null<Int> {
		var a = [for (k in hash.keys()) k];
		a.sort(asort);
		var i:Int = 0;
		for (k in a) {
			var j:Int = hash[k];
			for (n in i...(i + j)) if (compare(data[n], e)) return k;
			i += j;
		}
		return null;
	}
	
	private function asort(x:Int, y:Int):Int return x - y;
	
	/**
	 * @param	e Element for removing
	 */
	public function removeElement(e:T):Bool {
		var i:Int = data.indexOf(e);
		if (i == -1) return false;
		
		for (k in 0...counters.length)
			if (i < counters[k]) counters[k]--;
		data.remove(e);
		
		var a:Array<Int> = [for (k in hash.keys()) k];
		a.sort(asort);
		for (k in a) {
			var n = hash.get(k);
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
		
		if (double) removeElement(e);
		return true;
	}
	
	public function removeFunction(f:T->Bool):Bool {
		var e:T = search(f);
		return if (e != null) removeElement(e);
		else false;
	}
	
	public function removeArray(a:Array<T>):Bool {
		var f:Bool = true;
		for (e in a) if (!removeElement(e)) f = false;
		return f;
	}
	
	/**
	 * All elements taking new priority, but save order.
	 * @param	priority New priority, default 0
	 */
	public function repriority(priority:Int = 0):Void {
		hash = new Map<Int,Int>();
		hash.set(priority, data.length);
	}
	
	public function changeElement(e:T, priority:Int = 0):Priority<T> {
		if (removeElement(e)) addElement(e, priority);
		else throw 'Element not exists';
		return this;
	}
	
	public function changeFunction(f:T->Bool, priority:Int = 0):Priority<T> {
		var e:T = search(f);
		return changeElement(e, priority);
	}
	
	public function changeArray(a:Array<T>, priority:Int = 0):Priority<T> {
		for (e in a) changeElement(e, priority);
		return this;
	}
	
	public inline function toString():String return data.toString();
	
	public inline function join(sep:String):String return data.join(sep);
	
	private inline function get_first():T return data[0];
	
	private inline function get_last():T return data[data.length - 1];
	
	private inline function get_length():Int return data.length;
	
	/**
	 * @return True if priority list not have element and false if have.
	 */
	private inline function get_empty():Bool return data.length == 0;
	
	/**
	 * Make infinity loop. This good method for devolopment UI.
	 * @return Next element in loop.
	 */
	public function loop():T {
		if (counters[0] >= length) {
			counters[0] = 0;
			if (empty) return null;
		}
		return data[counters[0]++];
	}
	
	/**
	 * Next time loop return first element.
	 */
	public inline function resetLoop():Priority<T> {
		counters[0] = 0;
		return this;
	}

	/**
	 * Start loop from custom element.
	 * Use exists() before call this function for safely run.
	 * @param	e first element for loop.
	 */
	public inline function reloop(e:T):Void while (loop() != e) null;
	
	/**
	 * @return Current element in loop.
	 */
	private inline function get_current():T {
		return if (counters[0] > length) data[0] else if (counters[0] < 1) data[length - 1] else data[counters[0] - 1];
	}
	
	/**
	 * Make infinity loop. This good method for devolopment UI.
	 * @return Previos element in loop.
	 */
	public function backLoop():T {
		if (empty) {
			counters[0] = 0;
			return null;
		}
		counters[0]--;
		if (counters[0] < 1) counters[0] = length;
		return data[counters[0] - 1];
	}
	
	/**
	 * Get minimal index.
	 */
	private function get_min():Int {
		var n:Null<Int> = null;
		for (k in hash.keys())
			if (n == null || k < n)
				n = k;
		return n;
	}
	
	/**
	 * Get maximal index.
	 */
	private function get_max():Int {
		var n:Null<Int> = null;
		for (k in hash.keys())
			if (n == null || k > n)
				n = k;
		return n;
	}
	
	/**
	 * Add element with lowest priority.
	 * @param	o T or Array&lt;T&gt;.
	 */
	inline public function addElementToBegin(e:T):Void addElement(e, min - 1);
	
	/**
	 * Add element with hightest priority.
	 * @param	o T or Array&lt;T&gt;.
	 */
	inline public function addElementToEnd(e:T):Void addElement(e, max + 1);
	
	public static function createIds(a:Array<String>):PriorityIds {
		var i:Int = 0;
		return new Priority([for (e in a) { id:i++, name:e } ]);
	}
	
}