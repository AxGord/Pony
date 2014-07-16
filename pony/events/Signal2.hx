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
 * Signal2
 * @author AxGord <axgord@gmail.com>
 */
abstract Signal2<Target, T1:Dynamic, T2:Dynamic>(Signal) {

	public var silent(get,set):Bool;
	public var lostListeners(get, never):Signal0<Signal2<Target, T1, T2>>;
	public var takeListeners(get, never):Signal0<Signal2<Target, T1, T2>>;
	public var haveListeners(get, never):Bool;
	public var data(get, set):Dynamic;
	public var target(get, never):Target;
	public var listenersCount(get, never):Int;
	
	inline private function new(s:Signal) this = s;
	
	inline private function get_silent():Bool return this.silent;
	inline private function set_silent(b:Bool):Bool return this.silent = b;
	
	inline private function get_lostListeners():Signal0<Signal2<Target, T1, T2>> return cast this.lostListeners;
	inline private function get_takeListeners():Signal0<Signal2<Target, T1, T2>> return cast this.takeListeners;
	inline private function get_haveListeners():Bool return cast this.haveListeners;
	
	inline private function get_data():Dynamic return this.data;
	inline private function set_data(d:Dynamic):Dynamic return this.data = d;
	inline private function get_target():Target return this.target;
	inline private function get_listenersCount():Int return this.listenersCount;
	
	public function add(listener:Listener2<Target, T1, T2>, priority:Int = 0):Target {
		this.add(listener, priority);
		return target;
	}
	
	public function once(listener:Listener2<Target, T1, T2>, priority:Int = 0):Target {
		this.once(listener, priority);
		return target;
	}
	
	public function remove(listener:Listener2<Target, T1, T2>):Target {
		this.remove(listener);
		return target;
	}
	
	inline public function changePriority(listener:Listener2<Target, T1, T2>, priority:Int = 0):Target {
		this.changePriority(listener, priority);
		return target;
	}
	#if cs
	public function dispatch(a:Dynamic, b:Dynamic):Target return dispatchArgs([a, b]);
	#else
	public function dispatch(a:T1, b:T2):Target return dispatchArgs([a, b]);
	#end
	
	public function dispatchEvent(event:Event):Target {
		this.dispatchEvent(event);
		return target;
	}
	
	inline public function dispatchArgs(?args:Array<Dynamic>):Target {
		this.dispatchArgs(args);
		return target;
	}
	
	inline public function sub(a:T1, ?b:T2, priority:Int=0):Signal return subArgs(b == null ? [a] : [a,b], priority);
	
	inline public function sub1(a:T1, priority:Int=0):Signal1<Target, T2> return subArgs([a], priority);
	inline public function sub2(a:T1, b:T2, priority:Int=0):Signal0<Target> return subArgs([a, b], priority);
	
	inline public function subArgs(args:Array<Dynamic>, priority:Int=0):Signal return this.subArgs(args, priority);
	
	inline public function removeSub(a:T1, ?b:T2):Target return removeSubArgs(b == null ? [a] : [a,b]);
	
	inline public function removeSubArgs(args:Array<Dynamic>):Target {
		this.removeSubArgs(args);
		return target;
	}
	
	inline public function removeAllSub():Target {
		this.removeAllSub();
		return target;
	}
	
	inline public function not1(v:T1, priority:Int=0):Signal1<Target,T2> return this.notArgs([v], priority);
	inline public function not2(v1:T1, v2:T2, priority:Int=0):Signal0<Target> return this.notArgs([v1, v2], priority);
	
	inline public function removeAllListeners():Target {
		this.removeAllListeners();
		return target;
	}
	
	public function sw(l1:Listener2<Target,T1, T2>, l2:Listener2<Target,T1, T2>):Target {
		this.once(l1);
		this.once(this.sw.bind(l2, l1));
		return target;
	}
	
	inline public function destroy():Target {
		this.destroy();
		return target;
	}
	
	public function enableSilent():Void silent = true;
	public function disableSilent():Void silent = false;
	
	@:from static private inline function from<A,B,C>(s:Signal):Signal2<A,B,C> return new Signal2<A,B,C>(s);
	@:to private inline function to():Signal return this;
	
	@:to private inline function toFunction():T1->T2->Void return dispatch;
	@:to private inline function toFunction2():Event->Void return dispatchEvent;
	
	public inline function debug():Void this.debug();
	
	//Operators (experimental)
	
	@:op(A << B) inline private function op_add(listener:Listener2<Target,T1,T2>):Signal2<Target,T1,T2> {
		add(listener);
		return this;
	}
	
	@:op(A < B) inline private function op_once(listener:Listener2<Target,T1,T2>):Signal2<Target,T1,T2> {
		once(listener);
		return this;
	}
	
	@:op(A >> B) inline private function op_remove(listener:Listener2<Target,T1,T2>):Signal2<Target,T1,T2> {
		remove(listener);
		return this;
	}
	
	@:op(A - B) inline private function op_sub(a:T1):Signal1<Target, T2> return sub1(a);
	@:op(A / B) inline private function op_not(a:T1):Signal1<Target, T2> return not1(a);
}