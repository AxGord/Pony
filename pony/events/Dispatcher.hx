/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pony.magic.ArgsArray;
import pony.magic.Declarator;
import pony.Messages;

/**
 * Event Dispatcher
 * @author AxGord
 */

class Dispatcher implements ArgsArray, extends Messages//, implements Declarator
{
	private var signals:Hash<Signal>;
	private var delay:Int = -1;
	
	public function new(_delay:Int = -1) {
		this.delay = _delay;
		signals = new Hash<Signal>();
		super();
	}
	
	public function getSignal(name:String):Signal {
		if (!signals.exists(name))
			signals.set(name, new Signal(this.delay));
		return signals.get(name);
	}
	
	public function addListener(signal:String, ?l:Listener, ?he:Event->Void, ?hd:Dynamic, count:Int = Ultra.nullInt, priority:Int = Ultra.nullInt, delay:Int = Ultra.nullInt):Void {
		getSignal(signal).addListener(l, he, hd, count, priority, delay);
	}
	
	@ArgsArray public function dispatch(args:Array<Dynamic>):Event {
		if (args.length == 0) throw 'Please, say name';
		var name:String = args.shift();
		if (!signals.exists(name)) return null;
		return Reflect.callMethod(null, signals.get(name).dispatch, args);
	}
	
	public function removeListener(signal:String, ?l:Listener, ?he:Event->Void, ?hd:Dynamic):Void {
		if (!signals.exists(signal)) return;
		signals.get(signal).removeListener(l, he, hd);
	}
	
	public function changePriority(signal:String, ?l:Listener, ?he:Event->Void, ?hd:Dynamic, p:Int = 0):Void {
		if (!signals.exists(signal)) return;
		signals.get(signal).changePriority(l, he, hd, p);
	}
	
	public function wait(signal:String, ?l:Listener, ?he:Event->Void, ?hd:Dynamic):Void {
		getSignal(signal).wait(l, he, hd);
	}
	
	public function waitAsync(signal:String, ok:Event->Void, ?error:Dynamic->Void):Void {
		getSignal(signal).waitAsync(ok, error);
	}
	
}