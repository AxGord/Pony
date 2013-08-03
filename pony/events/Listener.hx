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

import pony.Dictionary;
import pony.Function;

using Lambda;

/**
 * ...
 * @author AxGord
 */

typedef Listener_ = { f:Function, count:Int, event:Bool, prev:Event, used:Int }
 
abstract Listener( Listener_ ) {
	
	public static var flist:Map<Int, Listener> = new Map<Int, Listener>();
	//public static var eflist:Dictionary<Event->Void, Listener> = new Dictionary<Event->Void, Listener>();
	
	inline public function new(f:Function, event:Bool = false, count:Int = -1) {
		f._use();
		this = {f:f, count:count, event:event, prev: null, used: 0}
	}
	
	@:from static public function fromEFunction(f:Event->Void):Listener
		return _fromFunction(Function.from1(f), true);
	
	@:from static public function fromFunction(f:Function):Listener
		return _fromFunction(f, false);
	
	static public function _fromFunction(f:Function, ev:Bool):Listener {
		if (flist.exists(f.id())) {
			return flist.get(f.id());
		} else {
			//trace(ev);
			var o:Listener = new Listener(f, ev);
			flist.set(f.id(), o);
			return o;
		}
    }
	
	inline public function count():Int return this.count;
	
	public function call(event:Event):Bool {
		this.count--;
		event._setListener(this);
		var r:Bool = true;
		if (this.event) {
			if (this.f._call([event]) == false) r = false;
		} else {
			if (this.f._call(event.args.slice(0, this.f.count())) == false) r = false;
		}
		this.prev = event;
		return r;
	}
	
	inline public function setCount(count:Int):Listener {
		return new Listener(this.f, this.event,  count);
	}
	
	inline public function _use():Void {
		this.used++;
	}
	
	inline public function unuse():Void {
		this.used--;
		if (this.used <= 0) {
			//if (this.event) {
			//	eflist.remove(this.f.get());
			//} else {
				flist.remove(this.f.id());
			//}
			this.f.unuse();
			this = null;
		}
	}
	
	inline public function used():Int return this.used;
	
	static public function unusedCount():Int {
		var c:Int = 0;
		for (l in flist) if (l.used() <= 0) c++;
		//for (l in eflist) if (l.used() <= 0) c++;
		return c;
	}
	
}
