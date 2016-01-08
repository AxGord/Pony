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

enum Listener0Type {
	LFunction0( f:Void->Bool );
	LEvent0( s:Event0, ?safe:Bool );
	LBind1( s:Event1<Dynamic>, v:Dynamic );
	LBind2( s:Event2<Dynamic, Dynamic>, v1:Dynamic, v2:Dynamic );
}

typedef Listener0_ = { once:Bool, listener:Listener0Type }

/**
 * @author AxGord <axgord@gmail.com>
 */
@:forward(once, listener)
abstract Listener0(Listener0_) to Listener0_ from Listener0_ {
	
	@:from @:extern inline private static function f0<T1>(f:Void->Void):Listener0 return { once:false, listener:LFunction0(cast f) };
	@:from @:extern inline private static function s0<T1>(f:Event0):Listener0 return { once:false, listener:LEvent0(f) };
	inline public function call(?safe:Bool):Bool return switch this.listener {
		case LFunction0(f): f();
		case LEvent0(s, sv): s.dispatch(sv||safe);
		case LBind1(s, v): s.dispatch(v, safe);
		case LBind2(s, v1, v2): s.dispatch(v1, v2, safe);
	}
	
}