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

enum Listener1Type<T1> {
	LFunction0( f:Void->Bool );
	LFunction1( f:T1->Bool );
	LEvent0( s:Event0, ?safe:Bool );
	LEvent1( s:Event1<T1>, ?safe:Bool );
	LSub( s:Event0, v:T1 );
	LNot( s:Event1<T1>, v:T1 );
	LBind1( s:Event2<T1, Dynamic>, v1:Dynamic );
}

typedef Listener1_ < T1 > = { once:Bool, listener:Listener1Type<T1> }

/**
 * Listener1
 * @author AxGord <axgord@gmail.com>
 */
@:forward(once, listener)
abstract Listener1<T1>(Listener1_<T1>) to Listener1_<T1> from Listener1_<T1> {
	
	@:from @:extern inline private static function f0<T1>(f:Void->Void):Listener1<T1> return { once:false, listener:LFunction0(cast f) };
	@:from @:extern inline private static function f1<T1>(f:T1->Void):Listener1<T1> return { once:false,  listener:LFunction1(cast f) };
	@:from @:extern inline private static function s0<T1>(f:Event0):Listener1<T1> return { once:false,  listener:LEvent0(f) };
	@:from @:extern inline private static function s1<T1>(f:Event1<T1>):Listener1<T1> return { once:false, listener:LEvent1(f) };
	inline public function call(a1:T1, ?safe:Bool):Bool return switch this.listener {
		case LFunction0(f): f();
		case LFunction1(f): f(a1);
		case LEvent0(s, sv): s.dispatch(sv||safe);
		case LEvent1(s, sv): s.dispatch(a1, sv||safe);
		case LSub(s, v) if (v == a1): s.dispatch(safe);
		case LNot(s, v) if (v != a1): s.dispatch(a1, safe);
		case LBind1(s, v1): s.dispatch(a1, v1, safe);
		case _: false;
	}
}