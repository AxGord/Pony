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
	#if debug
	public static var signalsCount:Int;
	public var id:Int;
	private static function __init__():Void signalsCount = 0;
	#end
	
	public var silent:Bool = false;
	public var lostListeners(default, null):Signal0<Signal>;
	public var takeListeners(default, null):Signal0<Signal>;
	public var data:Dynamic;
	public var target(default, null):Dynamic;
	
	private var listeners:Priority<Listener>;
	private var lRunCopy:List<Priority<Listener>>;
	
	private var subMap:Dictionary < Array<Dynamic>, Signal > ;
	private var subHandlers:Map < Int, Listener > ;
	private var bindMap:Dictionary < Array<Dynamic>, Signal > ;
	private var bindHandlers:Map < Int, Listener > ;
	private var notMap:Dictionary < Array<Dynamic>, Signal > ;
	private var notHandlers:Map < Int, Listener > ;
	
	public var haveListeners(get, null):Bool;
	
	public var listenersCount(get, never):Int;
	
	public var parent:Signal;
	
	public function new(?target:Dynamic) {
		subMap = new Dictionary < Array<Dynamic>, Signal > (5);
		subHandlers = new Map < Int, Listener >();
		bindMap = new Dictionary < Array<Dynamic>, Signal > (5);
		bindHandlers = new Map < Int, Listener >();
		notMap = new Dictionary < Array<Dynamic>, Signal > (5);
		notHandlers = new Map < Int, Listener >();
		init(target);
		lostListeners = Type.createEmptyInstance(Signal).init(this);
		takeListeners = Type.createEmptyInstance(Signal).init(this);
	}
	
	inline private function init(target:Dynamic):Signal {
		#if debug
		id = signalsCount++;
		#end
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
				#if debug
				throw 'Listener error (signal: $id)';
				#else
				throw 'Listener error';
				#end
				
				#elseif ((debug || munit) && (php || neko || cpp))
				
				Sys.println('');
				Sys.print(msg);
				Sys.println(CallStack.toString(CallStack.exceptionStack()));
				#if debug
				throw 'Listener error (signal: $id)';
				#else
				throw 'Listener error';
				#end
				
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
			if (l.get_count() == 0) remove(l);
			if (!r) break;
		}
		lRunCopy.remove(c);
		return this;
	}
	
	public inline function dispatchArgs(?args:Array<Dynamic>):Signal {
		dispatchEvent(new Event(args, target));
		return this;
	}
	
	public function dispatchEmpty():Void {
		dispatchEvent(new Event(null, target));
	}
	
	public function dispatchEmpty1(?_):Void {
		dispatchEvent(new Event(null, target));
	}
	
	macro public function sub(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				throw 'Arguments not set';
			else
				macro $th.subArgs([$a{args}], 0);
	}
	
	public function subArgs(args:Array<Dynamic>, priority:Int=0):Signal {
		var s:Signal = subMap.get(args);
		if (s == null) {
			s = new Signal(target);
			s.parent = this;
			var l:Listener = subHandler.bind(args);
			subHandlers[subMap.set(args, s)] = l;
			add(l, priority);
		}
		return s;
	}
	
	private function subHandler(args:Array<Dynamic>, event:Event):Void {
		var a:Array<Dynamic> = event.args.copy();
		for (arg in args) if (a.shift() != arg) return;
		subMap.get(args).dispatchEvent(new Event(a, event.target, event));
	}
	
	inline public function changeSubArgs(args:Array<Dynamic>, priority:Int=0):Signal {
		removeSubArgs(args);
		return subArgs(args, priority);
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
		s.destroy();
		return this;
	}
	
	inline public function removeAllSub():Signal {
		if (subMap != null) {
			for (e in subMap) e.destroy();
			subMap.clear();
		}
		return this;
	}
	
	private function removeSubSignal(s:Signal):Void {
		var i:Int = subMap.getValueIndex(s);
		if (i != -1) {
			s.remove(subHandlers[i]);
			subHandlers.remove(i);
			subMap.removeIndex(i);
		}
		var i:Int = bindMap.getValueIndex(s);
		if (i != -1) {
			s.remove(bindHandlers[i]);
			bindHandlers.remove(i);
			bindMap.removeIndex(i);
		}
		var i:Int = notMap.getValueIndex(s);
		if (i != -1) {
			s.remove(notHandlers[i]);
			notHandlers.remove(i);
			notMap.removeIndex(i);
		}
	}
	
	macro public function bind(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				throw 'Arguments not set';
			else
				macro $th.bindArgs([$a{args}]);
	}
	
	public function bindArgs(args:Array<Dynamic>, priority:Int=0):Signal {
		var s:Signal = bindMap.get(args);
		if (s == null) {
			s = new Signal(target);
			s.parent = this;
			var l:Listener = bindHandler.bind(args);
			bindHandlers[bindMap.set(args, s)] = l;
			add(l, priority);
		}
		return s;
	}
	
	private function bindHandler(args:Array<Dynamic>, event:Event):Void {
		bindMap.get(args).dispatchEvent(new Event(args.concat(event.args), event.target, event));
	}
	
	macro public function removeBind(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				throw 'Arguments not set';
			else
				macro $th.removeBindArgs([$a{args}]);
	}
	
	public function removeBindArgs(args:Array<Dynamic>):Signal {
		var s:Signal = bindMap.get(args);
		if (s == null) return this;
		s.destroy();
		return this;
	}
	
	inline public function removeAllBind():Signal {
		if (bindMap != null) {
			for (e in bindMap) e.destroy();
			bindMap.clear();
		}
		return this;
	}
	
	macro public function not(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				throw 'Arguments not set';
			else
				macro $th.bindArgs([$a{args}]);
	}
	
	public function notArgs(args:Array<Dynamic>, priority:Int=0):Signal {
		var s:Signal = bindMap.get(args);
		if (s == null) {
			s = new Signal(target);
			s.parent = this;
			var l:Listener = notHandler.bind(args);
			notHandlers[bindMap.set(args, s)] = l;
			add(l, priority);
		}
		return s;
	}
	
	private function notHandler(args:Array<Dynamic>, event:Event):Void {
		var a:Array<Dynamic> = event.args.copy();
		for (arg in args) if (a.shift() == arg) return;
		subMap.get(args).dispatchEvent(new Event(a, event.target, event));
	}
	
	macro public function removeNot(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				throw 'Arguments not set';
			else
				macro $th.removeNotArgs([$a{args}]);
	}
	
	public function removeNotArgs(args:Array<Dynamic>):Signal {
		var s:Signal = bindMap.get(args);
		if (s == null) return this;
		s.destroy();
		return this;
	}
	
	inline public function removeAllNot():Signal {
		if (notMap != null) {
			for (e in notMap) e.destroy();
			notMap.clear();
		}
		return this;
	}
	/*
	public function and(signal:Signal):Signal {
		var ns = new Signal(target);
		
	}*/
	
	public function removeAllListeners():Signal {
		//for (c in lRunCopy) c.clear();
		//lRunCopy.clear();
		//Not need coz auto clear all in dispatch
		var f:Bool = listeners.empty;
		for (l in listeners) l.unuse();
		listeners.clear();
		if (!f && lostListeners != null) lostListeners.dispatch();
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
	
	public function sw(l1:Listener, l2:Listener, priority:Int=0):Signal {
		once(l1, priority);
		once(sw.bind(l2, l1, priority), priority);
		return this;
	}
	
	public function enableSilent():Void silent = true;
	public function disableSilent():Void silent = false;
	
	inline private function get_listenersCount():Int return listeners.length;
	
	inline public function destroy():Void {
		//trace('destroy '+id);
		if (parent != null) parent.removeSubSignal(this);
		removeAllSub();
		removeAllBind();
		removeAllNot();
		removeAllListeners();
		if (takeListeners != null) takeListeners.destroy();
		if (lostListeners != null) lostListeners.destroy();
	}
	
	/**
	 * Strict construct
	 */
	inline public static function create<A>(t:A):SignalTar<A> return new SignalTar(new Signal(t));
	
	/**
	 * Empty strict construct
	 */
	inline public static function createEmpty():SignalTar<Void> return new SignalTar(new Signal());
}