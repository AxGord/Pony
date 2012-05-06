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

import pony.SpeedLimit;

using pony.Ultra;
using Lambda;

/**
 * @see pony.events.Signal
 * @author AxGord <axgord@gmail.com>
 */

class Listener {
	/**
	 * Handler Function, only get.
	 */
	public var handler(getHandler, null):Dynamic;
	
	/**
	 * Listener priority, if set then update all signals priority.
	 * @see pony.Priority
	 */
	public var priority(getPriority, setPriority):Int;
	
	/**
	 * Count runs.
	 */
	public var count:Int;
	
	/**
	 * Speed limit.
	 * @see pony.SpeedLimit
	 */
	public var delay(getDelay, setDelay):Int;
	
	private var _handler:Dynamic;
	private var _priority:Int;
	private var sendEvent:Bool;
	private var signals:List<Signal>;
	
	private var sl:SpeedLimit;
	
	/**
	 * Create new event listener.
	 * @param	?he Function listener with event argument.
	 * @param	?hd Function listener without event argument.
	 * @param	count Count runs.
	 * @param	priority Listener priority
	 * @param	delay Speed limit.
	 * @see pony.events.Event
	 */
	public function new(?he:Event->Void, ?hd:Dynamic, count:Int = -2147483648, priority:Int = -2147483648, delay:Int = -2147483648) {
		
		switch (Type.typeof(hd)) {
			case ValueType.TInt:
				delay = priority;
				priority = count;
				count = hd;
				hd = null;
			default:
		}
		if (delay == -2147483648) delay = -1;
		if (priority == -2147483648) priority = 0;
		if (count == -2147483648) count = 0;
		change(he, hd);
		this.count = count;
		_priority = priority;
		sl = new SpeedLimit(delay);
		signals = new List<Signal>();
	}
	
	private function change(?he:Event->Void, ?hd:Dynamic):Void {
		if ([he,hd].notNullCount() != 1)
			throw 'Give me ONE function, you send '+[he,hd].notNullCount();
		sendEvent = he.notNull();
		if (sendEvent)
			_handler = he;
		else
			_handler = hd;
	}
	
	private function getHandler():Dynamic {
		return _handler;
	}
	
	private function getPriority():Int {
		return _priority;
	}
	
	private function setPriority(p:Int):Int {
		if (p == priority) return p;
		for (s in signals)
			s.changePriority(this, p);
		return _priority = p;
	}
	
	
	/**
	 * Call handler, not use this functions. Use Signal dispath.
	 */
	public function dispatch(event:Event):Void {
		sl.run(function() {
			//if (count != -1) {
				event.listener = this;
				if (sendEvent) {
					handler(event);
				} else
					Reflect.callMethod(null, handler, event.args);
				if (count == 1) {
					remove();
				}
			//}
			
		});
	}
	
	/**
	 * Add signal for event. Invert style.
	 */
	public function addSignal(s:Signal):Void {
		if (signals.indexOf(s) != -1) return;
		signals.push(s);
		try {
			s.addListener(this, count, priority, delay);
		} catch (e:String) {}
	}
	
	/**
	 * Remove this listener from all signals.
	 */
	public function remove():Void {
		for (s in signals) {
			s.removeListener(this);
		}
	}

	private function getDelay():Int { return sl.delay; }
	
	private function setDelay(d:Int):Int { return sl.delay = d; }
	
	/**
	 * Not run next function after delay.
	 */
	public function abort():Void { sl.abort(); }
	
}