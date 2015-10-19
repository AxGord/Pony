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

private enum PairType {
	S0(p:Pair<Signal0, Listener0>);
	S1<T1>(p:Pair<Signal1<T1>, Listener1<T1>>);
	S2<T1, T2>(p:Pair<Signal2<T1, T2>, Listener2<T1, T2>>);
}

/**
 * SignalAndListener
 * @author AxGord <axgord@gmail.com>
 */
private abstract SignalAndListener(PairType) {

	@:extern inline private function new(p:PairType) this = p;
	
	@:from @:extern inline static function s0(p:Pair<Signal0, Listener0>):SignalAndListener {
		return new SignalAndListener(S0(p));
	}
	
	@:from @:extern inline static function s0f(p:Pair<Signal0, Void->Void>):SignalAndListener {
		return s0(new Pair(p.a, (p.b:Listener0)));
	}
	
	@:from @:extern inline static function s0e(p:Pair<Signal0, Event0>):SignalAndListener {
		return s0(new Pair(p.a, (p.b:Listener0)));
	}
	
	@:from @:extern inline static function s1<T1>(p:Pair<Signal1<T1>, Listener1<T1>>):SignalAndListener {
		return new SignalAndListener(S1(p));
	}
	
	@:from @:extern inline static function s1f<T1>(p:Pair<Signal1<T1>, T1->Void>):SignalAndListener {
		return s1(new Pair(p.a, (p.b:Listener1<T1>)));
	}
	
	@:from @:extern inline static function s1e<T1>(p:Pair<Signal1<T1>, Event1<T1>>):SignalAndListener {
		return s1(new Pair(p.a, (p.b:Listener1<T1>)));
	}
	
	@:from @:extern inline static function s2<T1, T2>(p:Pair<Signal2<T1, T2>, Listener2<T1, T2>>):SignalAndListener {
		return new SignalAndListener(S2(p));
	}
	
	@:from @:extern inline static function s2f<T1, T2>(p:Pair<Signal2<T1, T2>, T1->T2->Void>):SignalAndListener {
		return s2(new Pair(p.a, (p.b:Listener2<T1, T2>)));
	}
	
	@:from @:extern inline static function s2e<T1, T2>(p:Pair<Signal2<T1, T2>, Event2<T1, T2>>):SignalAndListener {
		return s2(new Pair(p.a, (p.b:Listener2<T1, T2>)));
	}
	
	@:extern inline public function enable():Void {
		switch this {
			case S0(p): p.a << p.b;
			case S1(p): p.a << p.b;
			case S2(p): p.a << p.b;
		}
	}
	
	@:extern inline public function disable():Void {
		switch this {
			case S0(p): p.a >> p.b;
			case S1(p): p.a >> p.b;
			case S2(p): p.a >> p.b;
		}
	}
	
	@:extern inline public function once():Void {
		switch this {
			case S0(p): p.a < p.b;
			case S1(p): p.a < p.b;
			case S2(p): p.a < p.b;
		}
	}
	
}

/**
 * Roll
 * @author AxGord <axgord@gmail.com>
 */
abstract Roll(Array<SignalAndListener>) from Array<SignalAndListener> {

	@:extern inline public function new(p:Array<SignalAndListener>) this = p;
	
	public function enable():Void for (e in this) e.enable();
	public function once():Void for (e in this) e.once();
	public function disable():Void for (e in this) e.disable();
	
}