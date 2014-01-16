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

/**
 * Listener
 * @author AxGord
 */

typedef Listener_ = { f:Function, count:Int, event:Bool, prev:Event, used:Int, active:Bool, ignoreReturn:Bool }
 
abstract Listener( Listener_ ) {
	public static var flist:Map<Int, Listener>;
	
	public var active(get, set):Bool;
	public var count(get, never):Int;
	public var used(get, never):Int;
	
	private function __init__():Void {
		flist = new Map<Int, Listener>();
	}
	
	inline public function new(f:Function, event:Bool = false, ignoreReturn:Bool = true, count:Int = -1) {
		f._use();
		this = {f:f, count:count, event:event, prev: null, used: 0, active: true, ignoreReturn: ignoreReturn}
	}
	
	@:from static inline public function fromEFunction(f:Event->Void):Listener
		return _fromFunction(Function.from1(f), true);
	
	@:from static inline public function fromFunction(f:Function):Listener
		return _fromFunction(f, false);
		
	@:from static inline public function fromSignal(s:Signal):Listener
		return s.dispatchEvent;
		
	static public function _fromFunction(f:Function, ev:Bool):Listener {
		if (flist.exists(f.get_id())) {
			return flist.get(f.get_id());
		} else {
			var o:Listener = new Listener(f, ev);
			flist.set(f.get_id(), o);
			return o;
		}
    }
	
	inline public function get_count():Int return this.count;
	
	public function call(event:Event):Bool {
		if (!this.active) return true;
		this.count--;
		event._setListener(this);
		var r:Bool = true;
		if (this.event) {
			if (this.ignoreReturn) this.f.call([event]);
			else if (this.f.call([event]) == false) r = false;
		} else {
			var args:Array<Dynamic> = [];
			for (e in event.args) args.push(e);//copy for c#
			args.push(event.target);
			args.push(event);
			if (this.ignoreReturn) this.f.call(args.slice(0, this.f.get_count()));
			else if (this.f.call(args.slice(0, this.f.get_count())) == false) r = false;
		}
		this.prev = event;
		return event._stopPropagation ? false : r;
	}
	
	inline public function setCount(count:Int):Listener {
		return new Listener(this.f, this.event, this.ignoreReturn, count);
	}
	
	inline public function _use():Void this.used++;
	
	inline public function unuse():Void {
		this.used--;
		if (this.used == 0) {
			flist.remove(this.f.get_id());
			this.f.unuse();
		}
	}
	
	inline public function get_used():Int return this.used;
	
	static public function unusedCount():Int {
		var c:Int = 0;
		for (l in flist) if (l.get_used() <= 0) c++;
		return c;
	}
	
	inline public function get_active():Bool return this.active;
	
	inline public function set_active(b:Bool):Bool return this.active = b;
	
}
