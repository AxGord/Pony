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
	public var lostListeners(get, null):Signal0<Signal>;
	private var readyLostListeners:Bool = false;
	private function get_lostListeners():Signal0<Signal> {
		if (!readyLostListeners) {
			lostListeners = Signal.create(this);
			readyLostListeners = true;
		}
		return lostListeners;
	}
	
	public var takeListeners(get, null):Signal0<Signal>;
	private var readyTakeListeners:Bool = false;
	
	private function get_takeListeners():Signal0<Signal> {
		if (!readyTakeListeners) {
			takeListeners = Signal.create(this);
			readyTakeListeners = true;
		}
		return takeListeners; 
	}
	
	public var data:Dynamic;
	public var target(default, null):Dynamic;
	
	private var listeners:Priority<Listener>;
	private var lRunCopy:List<Priority<Listener>>;
	
	private var subMap(get, null):Dictionary < Array<Dynamic>, Signal > ;
	private var subMapReady:Bool = false;
	
	private function get_subMap():Dictionary < Array<Dynamic>, Signal > {
		if (!subMapReady) {
			subMap = new Dictionary < Array<Dynamic>, Signal > (5);
			subHandlers = new Map < Int, Listener >();
			subMapReady = true;
		}
		return subMap;
	}
	
	private var subHandlers:Map < Int, Listener > ;
	
	private var bindMap(get, null):Dictionary < Array<Dynamic>, Signal > ;
	private var bindMapReady:Bool = false;
	
	private function get_bindMap():Dictionary < Array<Dynamic>, Signal > {
		if (!bindMapReady) {
			bindMap = new Dictionary < Array<Dynamic>, Signal > (5);
			bindHandlers = new Map < Int, Listener >();
			bindMapReady = true;
		}
		return bindMap;
	}
	
	private var bindHandlers:Map < Int, Listener > ;
	
	private var notMap:Dictionary < Array<Dynamic>, Signal > ;
	private var notMapReady:Bool = false;
	
	private function get_notMap():Dictionary < Array<Dynamic>, Signal > {
		if (!notMapReady) {
			notMap = new Dictionary < Array<Dynamic>, Signal > (5);
			notHandlers = new Map < Int, Listener >();
			notMapReady = true;
		}
		return notMap;
	}
	
	private var notHandlers:Map < Int, Listener > ;
	
	private var listenersBuffer:Array<Listener>;
	
	public var haveListeners(get, null):Bool;
	
	public var listenersCount(get, never):Int;
	
	public var parent:Signal;
	
	public function new(?target:Dynamic) {
		#if debug
		id = signalsCount++;
		#end
		this.target = target;
		listeners = new Priority<Listener>();
		lRunCopy = new List<Priority<Listener>>();
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
		listener.use();
		var f:Bool = listeners.empty;
		listeners.addElement(listener, priority);
		if (f && readyTakeListeners) takeListeners.dispatchEmpty();
		return this;
	}
	
	/**
	 * Send only one argument: Listener or Event->Void or Function
	 */
	public function remove(listener:Listener, unuse:Bool = true):Signal {
		if (listeners.empty) return this;
		if (listeners.removeElement(listener)) {
			for (c in lRunCopy) c.removeElement(listener);
			if (unuse) listener.unuse();
			if (listeners.empty && readyLostListeners) lostListeners.dispatchEmpty();
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
	
	#if debug
	#if cs
	private static function csStackFilter(s:String):Bool {
		return stackFilter(s)
			&& s.indexOf('Called from EntryPoint__') == -1
			&& s.indexOf('Called from haxe') == -1
			&& s.indexOf('Called from System') == -1;
	}
	#end
	
	private static function stackFilter(s:String):Bool {
		return s.indexOf('pony.events.') == -1
			&& s.indexOf('Reflect.') == -1
			&& s.indexOf('Reflect::') == -1;
	}
	#end
	
	public function dispatchEvent(event:Event):Signal {
		if (listeners.length == 0 ) return this;
		event.signal = this;
		if (silent) return this;
		
		if (listenersBuffer == null) listenersBuffer = new Array<Listener>();
		while (listenersBuffer.length > 0) listenersBuffer.pop();
		for (k in 0...listeners.length) listenersBuffer.push(listeners.data[k]);
		
		var i:Int = 0;
		while (i < listenersBuffer.length)
		{
			var l = listenersBuffer[i];
			var r:Bool = false;
			#if debug
				try {
					r = l.call(event);
				}
				#if cs
				catch (e:cs.system.Exception) {
					#if (HUGS && !WITHOUTUNITY)
					
						if (e.InnerException != null) {
							var r:String = e.InnerException.StackTrace.split('\n')[0];
							if (r.indexOf('.hx') != -1) {
								var a = r.split('.hx:');
								var n:Int = Std.parseInt(a[1]) - 1;
								r = a[0] + '.hx:' + n;
							}
							var cs = CallStack.callStack();
							cs.shift();
							cs.shift();
							cs.shift();
							var s = CallStack.toString(cs);
							var rs:String = '';
							for (l in s.split(')\n')) if (l != '' && csStackFilter(l)) {
								var a = l.split('.hx line ');
								var n:Int = Std.parseInt(a[1]) - 1;
								rs += a[0] + '.hx:$n)\n';
							}
							unityengine.Debug.LogError(
								'Listener error: ' + e.InnerException.Message+'\n' +
								r + '\n' + rs + '\n\n\n\n\n');
						} else {
							var cs = CallStack.callStack();
							Sys.println(e.Message);
							var a = CallStack.exceptionStack();
							a.pop();
							a.pop();
							a.pop();
							a.pop();
							cs = a.concat(cs);
							var r:String = e.Message+'\n';
							for (s in CallStack.toString(cs).split('\n'))
								if (s != '' && csStackFilter(s)) {
									var a = s.split('.hx line ');
									var n:Int = Std.parseInt(a[1]) - 1;
									r += a[0] + ':$n)\n';
								}
							unityengine.Debug.LogError(r + '\n\n\n\n');
						}
					#else
						var cs = CallStack.callStack();
						if (e.InnerException != null) {
							Sys.println('Listener error: '+e.InnerException.Message);
							Sys.println(e.InnerException.StackTrace);
						} else {
							Sys.println(e.Message);
							var a = CallStack.exceptionStack();
							a.pop();
							a.pop();
							a.pop();
							a.pop();
							cs = a.concat(cs);
						}
						var r:String = '';
						for (s in CallStack.toString(cs).split('\n'))
							if (s != '' && csStackFilter(s))
								r += s + '\n';
						Sys.println(r + '\n\n\n\n');
					#end
					throw e;
				}
				#elseif js
				catch (e:js.Error) {
					var r = '';
					for (s in e.stack.split('\n')) {
						#if nodejs
						s = StringTools.replace(s, js.Node.__dirname+'\\file:\\', '');
						#end
						if (stackFilter(s)) r += '$s\n';
					}
					Sys.println(r + '\n\n\n\n');
					throw e;
				}
				catch (e:Dynamic) {
					Sys.println('Listener error: $e');
					var r = '';
					var cs = CallStack.callStack();
					cs.pop();
					for (s in CallStack.toString(CallStack.exceptionStack().concat(cs)).split('\n'))
						if (stackFilter(s)) r += '$s\n';
					Sys.println(r + '\n\n\n\n');
					throw e;
				}
				#elseif neko
				catch (e:String) {
					Sys.println('Listener error: $e');
					var r = '';
					var cs = CallStack.callStack();
					cs.pop();
					for (s in CallStack.toString(CallStack.exceptionStack().concat(cs)).split('\n'))
						if (stackFilter(s)) r += '$s\n';
					Sys.println(r + '\n\n\n\n');
					throw e;
				}
				#end
			#else
				r = l.call(event);
			#end
			if (l.get_count() == 0)
			{
				if (!listeners.empty && listeners.removeElement(l)) {
					listenersBuffer.remove(l);
					l.unuse();
					if (listeners.empty && readyLostListeners) lostListeners.dispatchEmpty();
					i--;
				}
			}
			if (!r) break;
			i++;
		}
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
		if (!subMapReady) return this;
		var s:Signal = subMap.get(args);
		if (s == null) return this;
		s.destroy();
		return this;
	}
	
	inline public function removeAllSub():Signal {
		if (subMapReady) {
			for (e in subMap) e.destroy();
			subMap.clear();
			subMapReady = false;
			subMap = null;
			subHandlers = null;
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
		if (!bindMapReady) return this;
		var s:Signal = bindMap.get(args);
		if (s == null) return this;
		s.destroy();
		return this;
	}
	
	inline public function removeAllBind():Signal {
		if (bindMapReady) {
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
		var s:Signal = notMap.get(args);
		if (s == null) {
			s = new Signal(target);
			s.parent = this;
			var l:Listener = notHandler.bind(args);
			notHandlers[notMap.set(args, s)] = l;
			add(l, priority);
		}
		return s;
	}
	
	private function notHandler(args:Array<Dynamic>, event:Event):Void {
		var a:Array<Dynamic> = event.args.copy();
		for (arg in args) if (a.shift() == arg) return;
		notMap.get(args).dispatchEvent(new Event(a, event.target, event));
	}
	
	macro public function removeNot(args:Array<Expr>):Expr {
		var th:Expr = args.shift();
		return if (args.length == 0)
				throw 'Arguments not set';
			else
				macro $th.removeNotArgs([$a{args}]);
	}
	
	public function removeNotArgs(args:Array<Dynamic>):Signal {
		if (!notMapReady) return this;
		var s:Signal = bindMap.get(args);
		if (s == null) return this;
		s.destroy();
		return this;
	}
	
	inline public function removeAllNot():Signal {
		if (notMapReady) {
			for (e in notMap) e.destroy();
			notMap.clear();
		}
		return this;
	}
	
	public function and(signal:Signal):Signal {
		var ns = new Signal();
		var lock1 = false;
		var lock2 = false;
		add(function(e1:Event) {
			if (lock1) return;
			lock2 = true;
			signal.once(function(e2:Event) {
				lock2 = false;
				ns.dispatchEvent(new Event(e1.args.concat(e2.args), target, e1));
			});
		});
		signal.add(function(e2:Event) {
			if (lock2) return;
			lock1 = true;
			once(function(e1:Event) {
				lock1 = false;
				ns.dispatchEvent(new Event(e1.args.concat(e2.args), target, e1));
			});
		});
		return ns;
	}
	
	public function or(signal:Signal):Signal {
		var ns = new Signal();
		add(ns);
		signal.add(ns);
		return ns;
	}
	
	public function removeAllListeners():Signal {
		//for (c in lRunCopy) c.clear();
		//lRunCopy.clear();
		//Not need coz auto clear all in dispatch
		var f:Bool = listeners.empty;
		for (l in listeners) l.unuse();
		listeners.clear();
		if (!f && readyLostListeners) lostListeners.dispatch();
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
		if (readyTakeListeners) {
			takeListeners.destroy();
			takeListeners =  null;
		}
		if (readyLostListeners) {
			lostListeners.destroy();
			lostListeners = null;
		}
	}
	
	inline public function debug():Void {
		#if debug
		add(function() trace('dispatch($id)'));
		#end
	}
	
	public function join(s:Signal):Signal {
		var la:Listener = null;
		var lb:Listener = null;
		
		la = function(event:Event):Void {
			lb.active = false;
			dispatchEvent(event);
			lb.active = true;
		}
		
		lb = function(event:Event):Void {
			la.active = false;
			s.dispatchEvent(event);
			la.active = true;
		}
		
		s.add(la);
		add(lb);
		return this;
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