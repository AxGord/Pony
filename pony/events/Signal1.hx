/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pony.events.Listener1;

/**
 * Signal1
 * @author AxGord <axgord@gmail.com>
 */
@:forward(
	empty,
	clear,
	min,
	max,
	add,
	remove,
	change,
	addToBegin,
	addToEnd,
	getPriority,
	exists,
	existsArray,
	addArray,
	removeArray
)
abstract Signal1<T1>(Priority<Listener1<T1>>) from Event1<T1> {

	
	@:extern inline public function once(e:Listener1<T1>, priority:Int = 0):Signal1<T1> {
		e.once = true;
		return this.add(e, priority);
	}
	
	@:op(A << B) @:extern inline private function op_add(listener:Listener1<T1>):Signal1<T1> {
		return this.add(listener);
	}
	
	@:op(A < B) @:extern inline private function once_op(listener:Listener1<T1>):Signal1<T1> {
		return once(listener);
	}
	
	@:op(A >> B) @:extern inline private function remove_op(listener:Listener1<T1>):Bool {
		return this.remove( listener );
	}
	
	public function sub(a1:T1, priority:Int = 0, once:Bool=false):Signal0 {
		for (e in this) switch e.listener {
			case LSub(sig, val) if (val == a1):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event0();
		this.add({ once:once, listener:LSub(s, a1) }, priority);
		return s;
	}
	
	@:op(A - B) @:extern inline private function sub_op(a1:T1):Signal0 {
		return sub(a1);
	}
	
	@:op(A -= B) @:extern inline public function removeSub(a1:T1):Bool {
		return this.remove({ once:false, listener:LSub(null, a1) });
	}
	
	public function not(a1:T1, priority:Int = 0, once:Bool = false):Signal1<T1> {
		for (e in this) switch e.listener {
			case LNot(sig, val) if (val == a1):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event1();
		this.add({ once:once, listener:LNot(s, a1) }, priority);
		return s;
	}

	@:op(A / B) @:extern inline private function not_op(a1:T1):Signal1<T1> {
		return not(a1);
	}
	
	@:op(A % B) @:extern inline private function not_op0(a1:T1):Signal0 {
		return not(a1);
	}
	
	@:op(A /= B) @:extern inline public function removeNot(a1:T1):Bool {
		return this.remove({ once:false, listener:LNot(null, a1) });
	}
	
	@:from @:extern inline private static function signal2<T1,T2>(s:Signal2<T1,T2>):Signal1<T1> {
		return cast s;
	}
	
	@:op(A || B) @:extern inline public function or(s:Signal1<T1>):Signal1<T1> {
		var ns = new Event1();
		this.add(ns);
		s.add(ns);
		return ns;
	}
	
	@:op(A | B) @:extern inline public function orOnce(s:Signal1<T1>):Signal1<T1> {
		var ns = new Event1();
		once(ns);
		s.once(ns);
		return ns;
	}
	
	@:op(A & B) public function andOnce<T2>(s:Signal1<T2>):Signal2<T1,T2> {
		var ns = new Event2();
		var listener1 = null;
		var listener2 = null;
		listener1 = function (a) {
			s.remove(listener2);
			s.once(ns.dispatch.bind(a));
		}
		listener2 = function (b) {
			this.remove(listener1);
			once(ns.dispatch.bind(_, b));
		}
		once(listener1);
		s.once(listener2);
		return ns;
	}
	
	@:op(A && B) public function and<T2>(s:Signal1<T2>):Signal2<T1, T2> {
		var ns = new Event2();
		var start:Void->Void = null;
		var listener1 = null;
		var listener2 = null;
		listener1 = function (a) {
			s.remove(listener2);
			s.once(ns.dispatch.bind(a));
			s.once(start);
		}
		listener2 = function (b) {
			this.remove(listener1);
			once(ns.dispatch.bind(_, b));
			once(start);
		}
		start = function () {
			once(listener1);
			s.once(listener2);
		}
		start();
		return ns;
	}
	
	@:extern inline public function convert0(f:Event0->T1->Void):Signal0 {
		var ns = new Event0();
		this.add(f.bind(ns));
		return ns;
	}
	
	@:extern inline public function convert1<ST1>(f:Event1<ST1>->T1->Void):Signal1<ST1> {
		var ns = new Event1();
		this.add(f.bind(ns));
		return ns;
	}
	
	@:extern inline public function convert2<ST1, ST2>(f:Event2<ST1, ST2>->T1->Void):Signal2<ST1, ST2> {
		var ns = new Event2();
		this.add(f.bind(ns));
		return ns;
	}
	
	@:extern inline public function join(s:Signal1<T1>):Signal1<T1> {
		this.add({once:false, listener:LEvent1((untyped s:Event1<T1>), true)});
		s.add({once:false, listener:LEvent1((this:Event1<T1>), true)});
		return this;
	}
	
	@:extern inline public function unjoin(s:Signal1<T1>):Signal1<T1> {
		this.remove((untyped s:Event1<T1>));
		s.remove((this:Event1<T1>));
		return this;
	}
}