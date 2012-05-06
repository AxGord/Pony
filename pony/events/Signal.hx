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
import pony.Priority;
import pony.SpeedLimit;

using pony.Ultra;


/**
 * Example: [
 * var signal:Signal = new Signal();
 * signal.addListener(function() trace('hi'));
 * signal.dispatch();
 * ----------
 * hi ]
 * If addListener after dispatch, you can write: [
 * var signal:Signal = new Signal(0);
 * signal.dispatch();
 * signal.addListener(function() trace('hi'));
 * ----------
 * hi ] And this work!
 * @author AxGord
 */

class Signal implements ArgsArray
{
	
	//private static var counter:Int = 0;
	//private var id:Int;
	
	/**
	 * Delay for dispatch in ms. Default -1. -1 - run without wait.
	 * @see SpeedLimit
	 */
	public var delay(getDelay, setDelay):Int;
	
	private var sl:SpeedLimit;
	private var pList:Priority<Listener>;
	
	/**
	 * @param delay Delay for dispatch in ms. Default -1. -1 - run without wait.
	 * @see pony.SpeedLimit
	 */
	public function new(delay:Int=-1)
	{
		//id = counter++; trace(id);
		sl = new SpeedLimit(delay);
		pList = new Priority<Listener>();
	}
	
	/**
	 * Examples: [
	 * signal.addListener(new Listener(function() trace('hi')));
	 * ][
	 * signal.addListener(function() trace('hi'));
	 * ][
	 * signal.addListener(function(event:Event) trace(event));
	 * ]
	 * Call with l or he or hd
	 * @param count Limit runs. If 0 then unlimited. Default 0.
	 * @param priority Default 0.
	 * @param delay Delay for call in ms. Default -1. -1 - run without wait.
	 * @see pony.SpeedLimit for param delay
	 * @see pony.Priority for param priority.
	 * @see pony.events.Listener
	 * @see pony.events.Event
	 */
	public function addListener(?l:Listener, ?he:Event->Void, ?hd:Dynamic, count:Int = -2147483648, priority:Int = -2147483648, delay:Int = -2147483648):Void {
		if (l.notNull()) {
			if (pList.exists(l)) throw 'Listener exists';
		} else {
			l = new Listener(he, hd, count, priority, delay);
			
		}
		if (pList.exists(function(o:Listener) {
			return o.handler == l.handler;
		}) ) throw 'Listener exists';
		
			
		pList.add(l, l.priority);
		l.addSignal(this);
		if (pList.array.length == 1)
			haveListener();
	}
	
	/**
	 * Example: [
	 * dispatch(new Event());
	 * dispatch();
	 * dispatch(1, 2, 3); ]
	 */
	@ArgsArray public function dispatch(args:Array<Dynamic>):Event {
		//trace(id);
		var event:Event;
		if (args.length == 0)
			event = new Event();
		else if (Std.is(args[0], Event)) {
			event = args.shift();
			event.args = event.args.concat(args);
		} else
			event = new Event(args);
		sl.run(function() {
			var ra:Array < Void->Void > = [];
			event.runAfter = function(f:Void->Void) ra.push(f);
			if (event.target.isNull())
				event.target = this;
			event.signal = this;
			for (l in pList) {
				l.dispatch(event);
				if (event.stop || event.abort) break;
			}
			if (!event.abort)
				for (f in ra) f();
			if (event.stop || event.abort)
				for (l in pList)
					l.abort();
		});
		return event;
	}
	
	/**
	 * Send only one argument: Listener or Event->Void or Function
	 */
	public function removeListener(?l:Listener, ?he:Event->Void, ?hd:Dynamic):Void {
		switch ([l, he, hd].argCase()) {
			case 1: pList.remove(l);
			case 2: pList.remove(function(l:Listener) return l.handler == he);
			case 3: pList.remove(function(l:Listener) return l.handler == hd);
		}
		if (pList.array.length == 1)
			lostListener();
	}
	
	/**
	 * Send Listener or Event->Void or Function
	 * @param	p new priority, default 0
	 * @see pony.Priority for param priority.
	 */
	public function changePriority(?l:Listener, ?he:Event->Void, ?hd:Dynamic, p:Int=0):Void {
		switch ([l, he, hd].argCase()) {
			case 1: pList.change(l, p);
			case 2: pList.change(function(l:Listener) return l.handler == he, p);
			case 3: pList.change(function(l:Listener) return l.handler == hd, p);
		}
		l.priority = p;
	}
	
	private function getDelay():Int {
		return sl.delay;
	}
	
	private function setDelay(d:Int):Int {
		return sl.delay = d;
	}
	
	public function wait(?l:Listener, ?he:Event->Void, ?hd:Dynamic):Void {
		addListener(l, he, hd, 1);
	}
	
	public function waitAsync(ok:Event->Void, ?error:Dynamic->Void):Void {
		addListener(ok, 1);
	}
	
	dynamic public function haveListener():Void {}
	dynamic public function lostListener():Void { }
	
	public function removeAllListeners():Void {
		pList.clear();
		lostListener();
	}
	
}

