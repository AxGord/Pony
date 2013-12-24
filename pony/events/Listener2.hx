/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
 * Listener2
 * @author AxGord <axgord@gmail.com>
 */
abstract Listener2<Target, T1, T2>(Listener) {
	inline private function new(l:Listener) this = l;
	@:from inline private static function from0<T,A,B>(f:Void->Void):Listener2<T,A,B> return new Listener2(f);
	@:from inline private static function fromEvent<T,A,B>(f:Event->Void):Listener2<T,A,B> return new Listener2(f);
	@:from inline private static function from1<T,A,B>(f:A->Void):Listener2<T,A,B> return new Listener2(f);
	@:from inline private static function from1Tar<T,A,B>(f:A->T->Void):Listener2<T,A,B> return new Listener2(f);
	@:from inline private static function from2<T,A,B>(f:A->B->Void):Listener2<T,A,B> return new Listener2(f);
	@:from inline private static function from2Tar<T,A,B>(f:A->B->T->Void):Listener2<T,A,B> return new Listener2(f);
	@:to inline private function to():Listener return this;
	
	@:from inline private static function fromListener(f:Listener):Listener2<Target,T1,T2> return new Listener2(f);
	
	@:from static inline public function fromSignal0<A>(s:Signal0<A>):Listener2<A, Void, Void> return s.dispatchEvent;
	@:from static inline public function fromSignal1<A, B>(s:Signal1<A, B>):Listener2<A, B, Void> return s.dispatchEvent;
	@:from static inline public function fromSignal2<A, B, C>(s:Signal2<A, B, C>):Listener2<A, B, C> return s.dispatchEvent;
}