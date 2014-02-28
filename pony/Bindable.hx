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

import pony.events.Listener1;
import pony.events.Signal;
import pony.Pair;
import pony.events.Signal1;

/**
 * Bindable
 * @author AxGord <axgord@gmail.com>
 */
abstract Bindable < T > (Pair < T, Signal1 < Void, T > >) {
	
	public var signal(get, never):Signal1 < Void, T >;
	public var value(get, never):T;
	
	inline public function new(v:T) {
		this = new Pair < T, Signal1 < Void, T >> (v, Signal.createEmpty());
		this.b.add(silentSet);
	}
	
	public function silentSet(v:T):Void this.a = v;
	
	@:op(A << B) inline private static function _set<A>(a:Bindable<A>, b:A):Bindable<A> {
		if (a.value != b) a.signal.dispatch(b);
		return a;
	}
	
	inline public function dispatch():Void signal.dispatch(value);
	
	@:op(A << B) inline private static function _add<A>(a:Bindable<A>, b:Listener1<Void, A>):Bindable<A> {
		a.signal.add(b);
		return a;
	}
	
	@:op(A << B) inline private static function _remove<A>(a:Bindable<A>, b:Listener1<Void, A>):Bindable<A> {
		a.signal.remove(b);
		return a;
	}
	
	inline private function get_signal():Signal1 < Void, T > return this.b;
	
	@:to inline private function get_value():T return this.a;
	@:to inline public function toString():String return Std.string(this.a);
	@:to inline public function toDynamic():Dynamic return this.a;
	
}