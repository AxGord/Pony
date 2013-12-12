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
import pony.Dictionary;
import pony.Priority;
import haxe.CallStack;

#if macro
import haxe.macro.Expr;
#end
/**
 * Dynamic Signal
 * @author AxGord
 */

class Signal {
	
	public var silent:Bool = false;
	public var lostListeners(default, null):Signal0<Signal>;
	public var takeListeners(default, null):Signal0<Signal>;
	public var data:Dynamic;
	public var target(default, null):Dynamic;
	
	private var listeners:Priority<Listener>;
	private var lRunCopy:List<Priority<Listener>>;
	
	private var subMap:Dictionary < Array<Dynamic>, Signal > ;
	
	public var haveListeners(get, null):Bool;
	
	public var listenersCount(get, never):Int;
	
	public function new(?target:Dynamic) {
		subMap = new Dictionary < Array<Dynamic>, Signal > (5);
		init(target);
		lostListeners = Type.createEmptyInstance(Signal).init(this);
		takeListeners = Type.createEmptyInstance(Signal).init(this);
	}
	
	inline private function init(target:Dynamic):Signal {
		this.target = target;
		listeners = new Priority<Listener>();
		lRunCopy = new List<Priority<Listener>>();
		return this;
	}
	
	/**
	 * Examples: [
	 * signal.add(new Listener(function() trace('hi')));
	 * ][
	 * signal.add(function() trace('hi'));
	 * ][
	 * signal.add(function(event:Event) trace(event));
	 * ]
	 * Call with l or he or hd
	 * @param priority Default 0.
	 * @param delay Delay for call in ms. Default -1. -1 - run without wait.
	 * @see pony.Priority for param priority.
	 * @see pony.events.Listener
	 * @see pony.events.Event
	 */
	public function add(listener:Listener, priority:Int = 0):Signal {
		listener._use();
		var f:Bool = listeners.empty;
		listeners.addElement(listener, priority);
		if (f && takeListeners != null) takeListeners.dispatchEmpty();
		return this;
	}
	
	/**
	 * Send only one argument: Listener or Event->Void or Function
	 */
	public function remove(listener:Listener):Signal {
		if (listeners.empty) return this;
		if (listeners.removeElement(listener)) {
			for (c in lRunCopy) c.removeElement(listener);
			listener.unuse();
			if (listeners.empty && lostListeners != null) lostListeners.dispatchEmpty();
		}
		return this;
	}
	
	/**
	 * Send Listener or Event->Void or Function
	 * @param	p new priority, default 0
	 * @see pony.Priority for param priority.
	 */
	public inline function changePriority(listener:Listener, priority:Int=0):Signal {
		listeners.changeElement(listener, priority);
		return this;
	}
	
	public inline function once(listener:Listener, priority:Int = 0):Signal {
		return add(listener.setCount(1), priority);
	}
	
	/**
	 * Example: [
	 * dispatch(new Event());
	 * dispatch();
	 * dispatch(1, 2, 3); ]
	 */
	macro public function dispatch(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				macro $th.dispatchArgs([]);
			else if (args[0].expr.getParameters()[0].name == 'Event')
				macro $th.dispatchEvent($e { args[0] } );
			else
				macro $th.dispatchArgs([$a{args}]);
	}
	
	public function dispatchEvent(event:Event):Signal {
		event.signal = this;
		if (silent) return this;
		var c:Priority<Listener> = new Priority<Listener>(listeners.data.copy());
		lRunCopy.add(c);
		for (l in c) {
			var r:Bool = false;
			try {
				r = l.call(event);
			} catch (msg:String) {
				remove(l);
				lRunCopy.remove(c);
				#if (debug && cs)
				trace(msg);
				l.call(event);
				throw 'Listener error';
				#elseif (debug || munit)
				Sys.println('');
				Sys.print(msg);
				Sys.println(CallStack.toString(CallStack.exceptionStack()));
				throw 'Listener error';
				#else
				throw msg;
				#end
			} catch (e:Dynamic) {
				remove(l);
				lRunCopy.remove(c);
				try {
					trace(e.pos);
				} catch (e:Dynamic) {}
				throw e;
			}
			var br:Bool = r == false || event._stopPropagation;
			if (l.get_count() == 0) remove(l);
			if (br) break;
		}
		lRunCopy.remove(c);
		return this;
	}
	
	public inline function dispatchArgs(?args:Array<Dynamic>):Signal {
		dispatchEvent(new Event(args, target));
		return this;
	}
	
	public function dispatchEmpty(?_):Signal {
		dispatchEvent(new Event(null, target));
		return this;
	}
	
	macro public function sub(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				throw 'Arguments not set';
			else
				macro $th.subArgs([$a{args}]);
	}
	
	//todo: save sub signals
	public function subArgs(args:Array<Dynamic>):Signal {
		var s:Signal = subMap.get(args);
		if (s == null) {
			s = new Signal(target);
			s.data = args;
			add(subHandler.bind(args));
			subMap.set(args, s);
		}
		return s;
	}
	
	private function subHandler(args:Array<Dynamic>, event:Event):Void {
		var a:Array<Dynamic> = event.args.copy();
		for (arg in args) if (a.shift() != arg) return;
		subMap.get(args).dispatchEvent(new Event(a, event.target, event));
	}
	
	macro public function removeSub(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				throw 'Arguments not set';
			else
				macro $th.removeSubArgs([$a{args}]);
	}
	
	public function removeSubArgs(args:Array<Dynamic>):Signal {
		var s:Signal = subMap.get(args);
		if (s == null) return this;
		s.removeAllListeners();
		subMap.remove(args);
		return this;
	}
	
	inline public function removeAllSub():Signal {
		for (e in subMap) e.removeAllListeners();
		subMap.clear();
		return this;
	}
	
	public function removeAllListeners():Signal {
		for (c in lRunCopy) c.clear();
		lRunCopy.clear();
		var f:Bool = listeners.empty;
		for (l in listeners) l.unuse();
		listeners.clear();
		if (!f) lostListeners.dispatch();
		return this;
	}
	
	macro public function buildListener(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				macro $th.buildListenerEmpty();
			else
				macro $th.buildListenerArgs([$a{args}]);
	}
	
	inline public function buildListenerEvent(event:Event):Listener return function():Void dispatchEvent(event);
	inline public function buildListenerArgs(args:Array<Dynamic>):Listener return buildListenerEvent(new Event(args, target));
	inline public function buildListenerEmpty():Listener return buildListenerEvent(new Event(null, target));
		
	inline private function get_haveListeners():Bool return !listeners.empty;
	
	inline public function listen(s:Signal):Signal {
		s.add(dispatchEvent);
		return this;
	}
	
	public function sw(l1:Listener, l2:Listener):Signal {
		once(l1);
		once(sw.bind(l2, l1));
		return this;
	}
	
	public function enableSilent():Void silent = true;
	public function disableSilent():Void silent = false;
	
	inline private function get_listenersCount():Int return listeners.length;
	
	inline public function destroy():Void {
		removeAllSub();
		removeAllListeners();
		takeListeners.destroy();
		lostListeners.destroy();
	}
	
	/**
	 * Strict construct
	 */
	public static function create<A>(t:A):SignalTar<A> return new SignalTar(new Signal(t));
	
	/**
	 * Empty strict construct
	 */
	public static function createEmpty():SignalTar<Void> return new SignalTar(new Signal());
}