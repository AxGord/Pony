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

import haxe.Log;
import haxe.PosInfos;
import pony.Priority;
import pony.events.Listener0;

/**
 * Signal0
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
abstract Signal0(Priority<Listener0>) from Event0 {
	
	@:op(A >> B) @:extern inline private function remove_op(e:Listener0):Signal0 {
		this.remove( e );
		return this;
	}
	
	@:extern inline public function once(e:Listener0, priority:Int = 0):Signal0 {
		e.once = true;
		return this.add(e, priority);
	}
	
	@:op(A << B) @:extern inline private function add_op(listener:Listener0):Signal0 {
		return this.add(listener);
	}
	
	@:op(A < B) @:extern inline private function once_op(e:Listener0):Signal0 {
		return once(e);
	}
	
	@:op(A || B) @:extern inline public function or(s:Signal0):Signal0 {
		var ns = new Event0();
		this.add(ns);
		s.add(ns);
		return ns;
	}
	
	@:op(A | B) @:extern inline public function orOnce(s:Signal0):Signal0 {
		var ns = new Event0();
		once(ns);
		s.once(ns);
		return ns;
	}
	
	@:op(A & B) public function andOnce(s:Signal0):Signal0 {
		var ns = new Event0();
		var listener1 = null;
		var listener2 = null;
		listener1 = function () {
			s.remove(listener2);
			s.once(ns);
		}
		listener2 = function () {
			this.remove(listener1);
			once(ns);
		}
		once(listener1);
		s.once(listener2);
		return ns;
	}
	
	@:op(A && B) public function and(s:Signal0):Signal0 {
		var ns = new Event0();
		var start = null;
		var listener1 = null;
		var listener2 = null;
		listener1 = function () {
			s.remove(listener2);
			s.once(ns);
			s.once(start);
		}
		listener2 = function () {
			this.remove(listener1);
			once(ns);
			once(start);
		}
		start = function () {
			once(listener1);
			s.once(listener2);
		}
		start.call(false);
		return ns;
	}

	public function bind1<T1>(a1:T1, priority:Int = 0, _once:Bool = false):Signal1<T1> {
		for (e in this) switch e.listener {
			case LBind1(sig, val) if (val == a1):
				this.brk();
				return cast sig;
			case _:
		}
		var s = new Event1();
		this.add({ once:_once, listener:LBind1(s, a1) }, priority);
		return s;
	}
	
	@:op(A + B) @:extern inline private function bind1_op<T1>(a1:T1):Signal1<T1> {
		return bind1(a1);
	}
	
	@:op(A * B) @:extern inline private function bind1Once_op<T1>(a1:T1):Signal1<T1> {
		return bind1(a1, true);
	}
	
	@:extern inline public function removeBind1<T1>(a1:T1):Bool {
		return this.remove({ once:false, listener:LBind1(null, a1) });
	}
	
	public function bind2<T1,T2>(a1:T1, a2:T2, priority:Int = 0, _once:Bool = false):Signal2<T1,T2> {
		for (e in this) switch e.listener {
			case LBind2(sig, v1, v2) if (v1 == a1 && v2 == a2):
				this.brk();
				return cast sig;
			case _:
		}
		var s = new Event2();
		this.add({ once:_once, listener:LBind2(s, a1, a2) }, priority);
		return s;
	}
	
	@:extern inline public function removeBind2<T1,T2>(a1:T1,a2:T2):Bool {
		return this.remove({ once:false, listener:LBind2(null, a1, a2) });
	}
	
	@:from @:extern inline private static function fromSignal1<T1>(s:Signal1<T1>):Signal0 {
		var ns = new Event0();
		s.add(ns);
		return ns;
	}
	
	@:extern inline public function convert0(f:Event0->Void):Signal0 {
		var ns = new Event0();
		this.add(f.bind(ns));
		return ns;
	}
	
	@:extern inline public function convert1<ST1>(f:Event1<ST1>->Void):Signal1<ST1> {
		var ns = new Event1();
		this.add(f.bind(ns));
		return ns;
	}
	
	@:extern inline public function convert2<ST1, ST2>(f:Event2<ST1, ST2>->Void):Signal2<ST1, ST2> {
		var ns = new Event2();
		this.add(f.bind(ns));
		return ns;
	}
	
	@:extern inline public function join(s:Signal0):Signal0 {
		this.add({once:false, listener:LEvent0((untyped s:Event0), true)});
		s.add({once:false, listener:LEvent0((this:Event0), true)});
		return this;
	}
	
	@:extern inline public function unjoin(s:Signal0):Signal0 {
		this.remove((untyped s:Event0));
		s.remove((this:Event0));
		return this;
	}
	
	@:extern inline public function trace(?message:String, priority:Int=0, ?pos:PosInfos):Void {
		this.add(function() Log.trace(message, pos), priority);
	}
	
}