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
package pony.events;

/**
 * Signal0
 * @author AxGord <axgord@gmail.com>
 */
abstract Signal0<Target>(Signal) {
	public var silent(get,set):Bool;
	public var lostListeners(get, never):Signal0<Signal0<Target>>;
	public var takeListeners(get, never):Signal0<Signal0<Target>>;
	public var haveListeners(get, never):Bool;
	public var data(get, set):Dynamic;
	public var target(get, never):Target;
	public var listenersCount(get, never):Int;
	
	inline public function new(s:Signal) this = s;
	
	inline private function get_silent():Bool return this.silent;
	inline private function set_silent(b:Bool):Bool return this.silent = b;
	
	inline private function get_lostListeners():Signal0<Signal0<Target>> return cast this.lostListeners;
	inline private function get_takeListeners():Signal0<Signal0<Target>> return cast this.takeListeners;
	inline private function get_haveListeners():Bool return cast this.haveListeners;
	
	inline private function get_data():Dynamic return this.data;
	inline private function set_data(d:Dynamic):Dynamic return this.data = d;
	inline private function get_target():Target return this.target;
	inline private function get_listenersCount():Int return this.listenersCount;
	
	public function add(listener:Listener0<Target>, priority:Int = 0):Void {
		this.add(listener, priority);
		//return target;
	}
	
	public function once(listener:Listener0<Target>, priority:Int = 0):Void {
		this.once(listener, priority);
		//return target;
	}
	
	public function remove(listener:Listener0<Target>, unuse:Bool = true):Void {
		this.remove(listener, unuse);
		//return target;
	}
	
	
	inline public function changePriority(listener:Listener0<Target>, priority:Int = 0):Void {
		this.changePriority(listener, priority);
		//return target;
	}
	
	public function dispatch():Void {
		this.dispatchEmpty();
		//return target;
	}
	
	public function dispatchEvent(event:Event):Void {
		this.dispatchEvent(event);
		//return target;
	}
	
	inline public function dispatchArgs():Void {
		this.dispatchEmpty();
		//return target;
	}
	
	public function dispatchEmpty():Void this.dispatchEmpty();
	
	public function dispatchEmpty1(?_):Void this.dispatchEmpty();
	
	public function bind(a:Dynamic, ?b:Dynamic, ?c:Dynamic, ?d:Dynamic, ?e:Dynamic, ?f:Dynamic, ?g:Dynamic):Signal {
		return if (g != null)
			bindArgs([a, b, c, d, e, f, g]);
		else if (f != null)
			bindArgs([a, b, c, d, e, f]);
		else if (e != null)
			bindArgs([a, b, c, d, e]);
		else if (d != null)
			bindArgs([a, b, c, d]);
		else if (c != null)
			bindArgs([a, b, c]);
		else if (b != null)
			bindArgs([a, b]);
		else
			bindArgs([a]);
	}
	
	inline public function bindArgs(args:Array<Dynamic>, priority:Int = 0):Signal return this.bindArgs(args, priority);
	inline public function bind1<A>(a:A, priority:Int = 0):Signal1<Target, A> return bindArgs([a], priority);
	inline public function bind2<A,B>(a:A, b:B, priority:Int = 0):Signal2<Target, A, B> return bindArgs([a,b], priority);
	
	inline public function removeBindArgs(args:Array<Dynamic>):Void {
		this.removeBindArgs(args);
		//return target;
	}
	
	inline public function and(s:Signal):SignalTar<Target> return cast this.and(s);
	inline public function and0(s:Signal0<Dynamic>):Signal0<Target> return and(s);
	inline public function and1<A>(s:Signal1<Dynamic, A>):Signal1<Target, A> return and(s);
	inline public function and2<A,B>(s:Signal2<Dynamic, A, B>):Signal2<Target, A, B> return and(s);
	
	inline public function or(s:Signal0<Dynamic>):Signal0<Dynamic> return this.or(s);
	
	inline public function removeAllListeners():Void {
		this.removeAllListeners();
		//return target;
	}
	
	inline public function sw(l1:Listener0<Target>, l2:Listener0<Target>):Void {
		this.sw(l1, l2);
		//return target;
	}
	
	public function enableSilent():Void silent = true;
	public function disableSilent():Void silent = false;
	
	inline public function destroy():Void {
		this.destroy();
		//return target;
	}
	
	@:access(pony.events.Signal)
	inline public function join(s:Signal0<Target>):Signal0<Target> {
		for (l in this.listeners) s.add(cast l, -10);
		return this = s;
	}
	
	@:from static private inline function from<A>(s:Signal):Signal0<A> return new Signal0<A>(s);
	@:to public inline function toDynamic():Signal return this;
	public inline function toTar():SignalTar<Target> return cast this;
	
	@:to private inline function toFunction():Void->Void return dispatch;
	@:to private inline function toFunction2():Event->Void return dispatchEvent;
	
	public inline function debug():Void this.debug();
	
	@:op(A << B) inline private function op_add(listener:Listener0<Target>):Signal0<Target> {
		add(listener);
		return this;
	}
	
	@:op(A < B) inline private function op_once(listener:Listener0<Target>):Signal0<Target> {
		once(listener);
		return this;
	}
	
	@:op(A >> B) inline private function op_remove(listener:Listener0<Target>):Signal0<Target> {
		remove(listener);
		return this;
	}
	
	@:op(A << B) inline private function op_addSignal<A>(signal:Signal0<A>):Signal0<Target> {
		add(signal.dispatchEvent);
		return this;
	}
	
	@:op(A < B) inline private function op_onceSignal<A>(signal:Signal0<A>):Signal0<Target> {
		once(signal.dispatchEvent);
		return this;
	}
	
	@:op(A >> B) inline private function op_removeSignal<A>(signal:Signal0<A>):Signal0<Target> {
		remove(signal.dispatchEvent);
		return this;
	}
	
	@:op(A & B) inline private function op_and0(s:Signal0<Dynamic>):Signal0<Target> return and0(s);
	@:op(A & B) inline private function op_and1<A>(s:Signal1<Dynamic, A>):Signal1<Target, A> return and1(s);
	@:op(A & B) inline private function op_and2<A, B>(s:Signal2<Dynamic, A, B>):Signal2<Target, A, B> return and2(s);
	
	//@:op(A | B) inline private function op_or(s:Signal0<Dynamic>):Signal0<Target> return or(s);
	
	@:op(A + B) inline private function op_bind1<A>(a:A):Signal1<Target,A> return bind1(a);

}