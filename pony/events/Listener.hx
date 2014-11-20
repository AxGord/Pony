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
import pony.Function;

using Lambda;

typedef Listener_ = { count:Int, prev:Event, used:Int, active:Bool }

/**
 * Listener
 * @author AxGord
 */
@:forward(id, event)
abstract Listener(Function) from Function {
	public static var listeners:Map<Int, Listener_>;// = new Map<Int, Listener_>();

	inline private static function __init__():Void {
		listeners = new Map<Int, Listener_>();
	}
	
	public var active(get, set):Bool;
	public var count(get, never):Int;
	public var used(get, never):Int;
	public var ignoreReturn(get, never):Bool;
	public var listener(get, never):Listener_;
	private var exists(get,never):Bool;

	inline public function new(f:Function, count:Int = -1) {
		if (count == -1) {
			this = f;
			this._use();
		} else {
			this = f.copy();
			this._use();
			initListener(count);
		}
	}

	inline private function initListener(count:Int = -1):Void {
		if (!exists) listeners[this.id] = {count:count, prev: null, used:0, active:true};
	}

	inline public function get_exists():Bool return listeners.exists(this.id);
	inline public function get_listener():Listener_ return listeners[this.id];
	inline public function get_ignoreReturn():Bool return !this.ret;
	inline public function get_count():Int return exists ? listener.count : -1;
	inline public function get_active():Bool return exists ? listener.active : true;
	inline public function set_active(b:Bool):Bool {
		initListener();
		return listener.active = b;
	}
	inline public function get_used():Int return this.used;
   
	inline public function setCount(count:Int):Listener return new Listener(this, count);
	
	inline public function use():Void {
		initListener();
		listener.used++;
	}
	
	inline public function unuse():Void {
		initListener();
		listener.used--;
		if (this.used == 0) {
			listeners.remove(this.id);
			//flist.remove(this.f.get_id());
			this.unuse();
		}
	}
	
	static public function unusedCount():Int {
		var c:Int = 0;
		for (l in listeners) if (l.used <= 0) c++;
		return c;
	}
	
	public function call(_event:Event):Bool {
		initListener();
		if (!active) return true;
		listener.count--;
		_event._setListener(listener);
		var r:Bool = true;
		if (this.event) {
			if (ignoreReturn) this.call([_event]);
			else if (this.call([_event]) == false) r = false;
		} else {
			var args:Array<Dynamic> = [];
			for (e in _event.args) args.push(e);//copy for c#
			args.push(_event.target);
			args.push(_event);
			if (ignoreReturn) this.call(args.slice(0, this.get_count()));
			else if (this.call(args.slice(0, this.get_count())) == false) r = false;
		}
		if (listener != null) listener.prev = _event;
		return _event._stopPropagation ? false : r;
	}
	
	@:from inline static public function fromSignal(s:Signal):Listener return s.dispatchEvent;
	
}