/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.events;

import haxe.Log;
import haxe.PosInfos;
import pony.Priority;
import pony.events.Listener2;

/**
 * Signal2
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
abstract Signal2<T1,T2>(Priority<Listener2<T1,T2>>) from Event2<T1,T2> {

	
	@:extern inline public function once(e:Listener2<T1,T2>, priority:Int = 0):Signal2<T1,T2> {
		e.once = true;
		return this.add(e, priority);
	}
	
	@:op(A << B) @:extern inline private function op_add(listener:Listener2<T1,T2>):Signal2<T1,T2> {
		return this.add(listener);
	}
	
	@:op(A < B) @:extern inline private function once_op(listener:Listener2<T1,T2>):Signal2<T1,T2> {
		return once(listener);
	}
	
	@:op(A >> B) @:extern inline private function remove_op(listener:Listener2<T1,T2>):Bool {
		return this.remove( listener );
	}
	
	public function sub(a1:T1, a2:T2, priority:Int = 0, once:Bool=false):Signal0 {
		for (e in this) switch e.listener {
			case LSub(sig, v1, v2) if (v1 == a1 && v2 == a2):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event0();
		this.add({ once:once, listener:LSub(s, a1, a2) }, priority);
		return s;
	}
	
	@:extern inline public function removeSub(a1:T1, a2:T2):Bool {
		return this.remove({ once:false, listener:LSub(null, a1, a2) });
	}
	
	public function sub1(a1:T1, priority:Int = 0, once:Bool=false):Signal1<T2> {
		for (e in this) switch e.listener {
			case LSub1(sig, v1) if (v1 == a1):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event1<T2>();
		this.add({ once:once, listener:LSub1(s, a1) }, priority);
		return s;
	}
	
	@:op(A - B) @:extern inline private function sub1_op(a1:T1):Signal1<T2> {
		return sub1(a1);
	}
	
	@:op(A -= B) @:extern inline public function removeSub1(a1:T1):Bool {
		return this.remove({ once:false, listener:LSub1(null, a1) });
	}
	
	public function sub2(a2:T2, priority:Int = 0, once:Bool=false):Signal1<T1> {
		for (e in this) switch e.listener {
			case LSub2(sig, v) if (v == a2):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event1<T1>();
		this.add({ once:once, listener:LSub2(s, a2) }, priority);
		return s;
	}
	
	@:extern inline private function sub2_op(a2:T2):Signal1<T1> {
		return sub2(a2);
	}
	
	@:extern inline public function removeSub2(a:T2):Bool {
		return this.remove({ once:false, listener:LSub2(null, a) });
	}
	
	public function not(a1:T1, a2:T2, priority:Int = 0, once:Bool = false):Signal2<T1, T2> {
		for (e in this) switch e.listener {
			case LNot(sig, v1, v2) if (v1 == a1 && v2 == a2):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event2();
		this.add({ once:once, listener:LNot(s, a1, a2) }, priority);
		return s;
	}
	
	@:extern inline public function removeNot(a1:T1, a2:T2):Bool {
		return this.remove({ once:false, listener:LNot(null, a1, a2) });
	}
	
	public function not1(a1:T1, priority:Int = 0, once:Bool = false):Signal2<T1, T2> {
		for (e in this) switch e.listener {
			case LNot1(sig, val) if (val == a1):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event2();
		this.add({ once:once, listener:LNot1(s, a1) }, priority);
		return s;
	}

	@:op(A / B) @:extern inline private function not_op(a1:T1):Signal2<T1,T2> {
		return not1(a1);
	}
	
	@:op(A % B) @:extern inline private function not_op1(a1:T1):Signal1<T2> {
		return not1(a1).shift();
	}
	
	@:op(A /= B) @:extern inline public function removeNot1(a1:T1):Bool {
		return this.remove({ once:false, listener:LNot1(null, a1) });
	}
	
	public function not2(a1:T2, priority:Int = 0, once:Bool = false):Signal2<T1, T2> {
		for (e in this) switch e.listener {
			case LNot2(sig, val) if (val == a1):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event2();
		this.add({ once:once, listener:LNot2(s, a1) }, priority);
		return s;
	}

	@:extern inline public function removeNot2(a1:T2):Bool {
		return this.remove({ once:false, listener:LNot2(null, a1) });
	}
	
	@:extern inline public function shift():Signal1<T2> {
		var s:Event1<T2> = new Event1<T2>();
		this.add(function(_,v)s.dispatch(v));
		return s;
	}
	
	@:extern inline public function convert0(f:Event0->T1->T2->Void):Signal0 {
		var ns = new Event0();
		this.add(f.bind(ns));
		return ns;
	}
	
	@:extern inline public function convert1<ST1>(f:Event1<ST1>->T1->T2->Void):Signal1<ST1> {
		var ns = new Event1();
		this.add(f.bind(ns));
		return ns;
	}
	
	@:extern inline public function convert2<ST1, ST2>(f:Event2<ST1,ST2>->T1->T2->Void):Signal2<ST1, ST2> {
		var ns = new Event2<ST1,ST2>();
		this.add(f.bind(ns));
		return ns;
	}
	
	@:op(A || B) @:extern inline public function or(s:Signal2<T1,T2>):Signal2<T1,T2> {
		var ns = new Event2();
		this.add(ns);
		s.add(ns);
		return ns;
	}
	
	@:op(A | B) @:extern inline public function orOnce(s:Signal2<T1,T2>):Signal2<T1,T2> {
		var ns = new Event2();
		once(ns);
		s.once(ns);
		return ns;
	}
	
	@:extern inline public function join(s:Signal2<T1,T2>):Signal2<T1,T2> {
		this.add({once:false, listener:LEvent2((untyped s:Event2 < T1, T2 >), true)});
		s.add({once:false, listener:LEvent2((this:Event2 < T1, T2 >), true)});
		return this;
	}
	
	@:extern inline public function unjoin(s:Signal2<T1,T2>):Signal2<T1,T2> {
		this.remove((untyped s:Event2 < T1, T2 >));
		s.remove((this:Event2 < T1, T2 >));
		return this;
	}
	
	@:extern inline public function trace(?message:String, priority:Int=0, ?pos:PosInfos):Void {
		this.add(function() Log.trace(message, pos), priority);
	}
}