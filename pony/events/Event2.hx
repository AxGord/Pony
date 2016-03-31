/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.events;

import pony.Priority;

/**
 * Event2
 * @author AxGord <axgord@gmail.com>
 */
@:forward(
	empty,
	onTake,
	onLost
)
abstract Event2<T1,T2>(Priority<Listener2<T1,T2>>) from Priority<Listener2<T1,T2>> to Priority<Listener2<T1,T2>> {

	@:extern inline public function new(double:Bool = false) {
		this = new Priority(double);
		this.compare = compare;
	}
	
	private static function compare<T1,T2>(a:Listener2<T1,T2>, b:Listener2<T1,T2>):Bool {
		return switch [a.listener, b.listener] {
			case [LFunction0(a), LFunction0(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LFunction1(a), LFunction1(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LFunction2(a), LFunction2(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LEvent0(a,_), LEvent0(b,_)]:
				a == b;
			case [LEvent1(a,_), LEvent1(b,_)]:
				a == b;
			case [LEvent2(a,_), LEvent2(b,_)]:
				a == b;
			case [LSub(_, a1, a2), LSub(_, b1, b2)]:
				a1 == b1 && a2 == b2;
			case [LSub1(_, a), LSub1(_, b)]:
				a == b;
			case [LSub2(_, a), LSub2(_, b)]:
				a == b;
			case [LNot(_, a1, a2), LNot(_, b1, b2)]:
				a1 == b1 && a2 == b2;
			case [LNot1(_, a), LNot1(_, b)]:
				a == b;
			case [LNot2(_, a), LNot2(_, b)]:
				a == b;
			case _: false;
		}
	}
	
	
	public function dispatch(a1:T1, a2:T2, safe:Bool = false):Bool {
		if (this == null || this.isDestroy() || (safe && this.counters.length > 1)) return false;
		this.lock = true;
		for (e in this) {
			if (this.isDestroy()) return false;
			if (e.once) this.remove(e);
			if (e.call(a1, a2, safe)) {
				this.brk();
				return true;
			}
		}
		this.lock = false;
		return false;
	}
	
	@:extern inline public function sub(a1:T1, a2:T2, priority:Int = 0):Event0 {
		return (new Event0():Signal0).add(dispatch.bind(a1, a2), priority);
	}
	
	@:extern inline public function subOnce(a1:T1, a2:T2, priority:Int = 0):Event0 {
		return cast (new Event0():Signal0).once(dispatch.bind(a1, a2), priority);
	}
	
	@:extern inline public function sub1(a1:T1, priority:Int = 0):Event1<T2> {
		return (new Event1():Signal1<T2>).add(dispatch.bind(a1), priority);
	}
	
	@:extern inline public function sub1Once(a1:T1, priority:Int = 0):Event1<T2> {
		return cast (new Event1():Signal1<T2>).once(dispatch.bind(a1), priority);
	}
	
	@:op(A - B) @:extern inline private function sub1_op(a1:T1):Event1<T2> {
		return sub1(a1);
	}
	
	@:extern inline public function sub2(a2:T2, priority:Int = 0):Event1<T1> {
		return (new Event1():Signal1<T1>).add(dispatch.bind(_, a2), priority);
	}
	
	@:extern inline public function sub2Once(a2:T2, priority:Int = 0):Event1<T1> {
		return cast (new Event1():Signal1<T1>).once(dispatch.bind(_, a2), priority);
	}
	
	@:op(A && B) @:extern inline public function and(s:Event2<T1,T2>):Event2<T1,T2> {
		return (new Event2():Signal2<T1,T2>).add(this).add(s);
	}
	
	@:op(A & B) @:extern inline public function andOnce(s:Event2<T1,T2>):Event2<T1,T2> {
		return (new Event2():Signal2<T1,T2>).add(this).add(s);
	}
	
	inline public function destroy():Void {
		if (this != null) this.destroy();
	}
}