/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import Type;

using Lambda;
using pony.Ultra;
using Std;

/**
 * This class help you build priority list. Example: [
 * var p:Priority<Int> = new Priority<Int>();
 * p.add(123);
 * p.add(22, -1);
 * p.toString();//[22, 123], 22 - first ]
 * @author AxGord
 */

class Priority<T>
{
	private var hash:IntHash<Int>;
	private var data:Array<T>;
	
	private var counters:Array<Int>;
	
	/**
	 * Total elements count.
	 */
	public var length(getLenght, null):Int;
	
	/**
	 * Lowest priority number.
	 */
	public var min(getMin, null):Int;
	
	/**
	 * Hightest priority number.
	 */
	public var max(getMax, null):Int;
	
	/**
	 * First element.
	 */
	public var first(getFirst, null):T;
	
	/**
	 * Last element.
	 */
	public var last(getLast, null):T;
	
	/**
	 * if true: [[1, 1, 3]] - normal. Default false.
	 */
	public var double:Bool;
	
	public var list(getList, setList):List<T>;
	
	public var array(getArray, setArray):Array<T>;
	
	public function new(?e:T, ?ea:Array<T>)
	{
		double = false;
		clear();
		if (e != null)
			add(e);
		else if (ea != null)
			add(ea);
	}
	
	/**
	 * Add element in priority list with custom priority.
	 * @param	oa Object for adding in list or objects array. Type T or Array&lt;T&gt;. I'm write Dynamic for flash platform. ?a:T - fail :(
	 * @param	priority priority, smalest first, bigest last, default 0 (0 - normal priority).
	 */
	public function add(ao:Dynamic, priority:Int = 0):Void {
		if (ao.is(Array)) {
			addArray(ao, priority);
			return;
		} else
			addElement(ao, priority);
	}
	
	public function addElement(o:T, priority:Int = 0):Void {
		if (!double && exists(o)) return;
		var s:Int;
		if (!hash.exists(priority))
			s = 0;
		else
			s = hash.get(priority);
		var c:Int = 0;
		for (k in hash.keys())
			if (k < priority) c += hash.get(k);
		c += s;
		data.insert(c, o);
		for (k in 0...counters.length)
			if (c < counters[k]) counters[k]++;
		hash.set(priority, s+1);
	}
	
	/**
	 * Add elements array in priority list with custom priority.
	 * @param	a elements array for adding.
	 * @param	priority priority, smalest first, bigest last, default 0 (0 - normal priority).
	 */
	public function addArray(a:Array<T>, priority:Int = 0):Void {
		for (e in a)
			add(e, priority);
	}
	
	private function getLenght():Int { return data.length; }
	
	private function getList():List<T> { return data.list(); }
	
	private function setList(l:List<T>):List<T> {
		clear();
		data = l.array();
		hash.set(0, data.length);
		return l;
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
		var n:Int = counters.push(0)-1;
		return {
			hasNext: function():Bool {
				if (counters[n].isNull()) counters[n] = 0;
				if (data[counters[n]].notNull())
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
	public function clear():Void {
		hash = new IntHash<Int>();
		data = [];
		counters = [0];
	}
	
	/* This not work for flash9 if T == TInt
	public function exists(?o:T, ?f:T->Bool):Bool {
		if ([o, f].boolSum() != 1)
			throw 'Give me ONE argument, you send ' + [o, f].boolSum();
			
		if (o.notNull())
			return data.exists(function(e:T):Bool return e == o);
		else
			return data.exists(f);
	}*/
		
	/**
	 * If argument T->Bool, function take first argument tested element and returt true for say: Search end, element exists.<br/>
	 * Example:[
	 * p.exists(function(a:Int):Bool return a == 3);
	 * ] Also you can use Array
	 * @param of T or T->Bool or Array&lt;T&gt; or Array&lt;T->Bool&gt;
	 * @return Return true if element exists, false if not exists.
	 */
	public function exists(of:Dynamic):Bool {
		if (of.is(Array)) {
			var a:Array<Dynamic> = of;
			for (e in a)
				if (exists(e))
					return true;
			return false;
		} else if (Type.typeof(of) == ValueType.TFunction)
			return data.exists(of);
		else
			return data.exists(function(e:T):Bool return e == of);
	}
	
	/**
	 * Some time need take object with custom value.
	 */
	public function search(f:T->Bool):T {
		var s:T = null;
		data.exists(function(e:T):Bool {
			if (f(e)) {
				s = e;
				return true;
			} else
				return false;
		});
		return s;
	}
	
	/**
	 * @param	o Elemnt for removing
	 */
	private function removeElement(o:T):Void {
		var i:Int = data.indexOf(o);
		for (k in 0...counters.length)
			if (i < counters[k]) counters[k]--;
		data.remove(o);
		var a:Array<Int> = [];
		for (k in hash.keys())
			a.push(k);
		a.sort(function(x:Int, y:Int):Int return x - y);
		for (k in a) {
			if (i > 0) {
				i -= hash.get(k);
			} else {
				hash.set(k, hash.get(k) - 1);
				break;
			}
		}
		if (double)
			if (exists(o))
				remove(o);
	}
	
	/**
	 * @param	oa T or Array&lt;T&gt; or T->Bool
	 */
	public function remove(oa:Dynamic):Void {
		if (Type.typeof(oa) == ValueType.TFunction) {
			var e:T = search(oa);
			if (e.notNull())
				removeElement(e);
		} else if (oa.is(Array)) {
			var a:Array<T> = oa;
			for (e in a)
				remove(e);
		} else
			removeElement(oa);
	}
	
	/**
	 * All elements taking new priority, but save order.
	 * @param	priority New priority, default 0
	 */
	public function repriority(priority:Int = 0):Void {
		hash = new IntHash<Int>();
		hash.set(priority, data.length);
	}
	
	/**
	 * Change new prioriy for element.
	 * @param	o T or Array&lt;T&gt; or T->Bool
	 * @param	priority New priority, default 0
	 */
	public function change(o:Dynamic, priority:Int = 0):Void {
		if (Type.typeof(o) == ValueType.TFunction) {
			var e:T = search(o);
			if (e.notNull()) {
				removeElement(e);
				add(e, priority);
			}
		} else {
			remove(o);
			add(o, priority);
		}
	}
	
	public function toString():String return data.toString()
	
	private function getFirst():T return data[0]
	
	private function getLast():T return data[data.length-1]
	
	/**
	 * @return True if priority list not have element and false if have.
	 */
	public function empty():Bool {
		for (k in data)
			return false;
		return true;
	}
	
	/**
	 * Make infinity loop. This good metod for devolopment UI.
	 * @return Next element in loop
	 */
	public function loop():T {
		if (data[counters[0]] == null) {
			if (empty()) return null;
			else counters[0] = 0;
		}
		return data[counters[0]++];
	}
	
	/**
	 * Next time loop return first element.
	 */
	public function resetLoop():Void {
		counters[0] = 0;
	}
		
	private function getArray():Array<T> return data.copy()
	
	private function setArray(a:Array<T>):Array<T> {
		clear();
		data = a;
		hash.set(0, data.length);
		return a;
	}
	
	private function getMin():Int {
		var n:Int = Ultra.nullInt;
		for (k in hash.keys())
			if (n.isNull() || k < n)
				n = k;
		return n;
	}
	
	private function getMax():Int {
		var n:Int = Ultra.nullInt;
		for (k in hash.keys())
			if (n.isNull() || k > n)
				n = k;
		return n;
	}
	
	/**
	 * Add element with lowest priority.
	 * @param	o T or Array&lt;T&gt;.
	 */
	public function addToBegin(o:Dynamic):Void { add(o, min - 1); }
	
	/**
	 * Add element with hightest priority.
	 * @param	o T or Array&lt;T&gt;.
	 */
	public function addToEnd(o:Dynamic):Void add(o, max + 1)
	
}