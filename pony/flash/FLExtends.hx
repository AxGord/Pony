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
package pony.flash;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;
import flash.Lib;
import pony.flash.ui.Button;
import pony.geom.Rect;
import pony.ui.gui.ButtonCore;

/**
 * Flash extends
 * @author AxGord
 */

typedef Sigid = {d:EventDispatcher, n:String};
 
class FLExtends {
	/*
	private static var signals:Map<Sigid, Signal> = new Map<Sigid, Signal>();
	
	public static function buildSignal(d:EventDispatcher, name:String):Signal {
		var sid:Sigid = { d:d, n:name };
		var s:Signal;
		if (!signals.exists(sid)) signals.set(sid, s = new Signal());
		else s = signals.get(sid);
		d.addEventListener(name, function(event:Event) s.dispatchArgs([event]));
		return s;
	}
	*/
	public inline static function v(f:Void->Void):Dynamic return function(Void) f();
	
	public static function childrens(d:DisplayObjectContainer):Iterator<DisplayObject> {
		var it:IntIterator = 0...d.numChildren;
		return {
			hasNext: it.hasNext,
			next: function():DisplayObject return d.getChildAt(it.next())
		};
	}
	
	public static function rect(r:Rectangle):Rect<Float> return { x: r.x, y: r.y, width: r.width, height: r.height };
	
	static public function border(rect:Rectangle, x:Float, ?y:Float):Rectangle {
		var r = rect.clone();
		if (y == null) y = x;
		r.x += x;
		r.y += y;
		r.width -= x * 2;
		r.height -= y * 2;
		return r;
	}
	
	inline public static function removeAllChild(d:DisplayObjectContainer):Void while (d.numChildren > 0) d.removeChildAt(0);
	
	public static function toCenter(o:DisplayObject, width:Float, height:Float):Void {
		var b = o.getBounds(Lib.current.stage);
		o.x = width/2 - (o.width/2 - (o.x - b.x));
		o.y = height/2 - (o.height/2 - (o.y - b.y));
	}
	
	public static function toScreenCenter(o:DisplayObject):Void toCenter(o, FLTools.width, FLTools.height);
	
	inline public static function getTyped<T:DisplayObject>(o:DisplayObjectContainer, name:String, cl:Class < T >):T return cast get(o, name);
	
	inline public static function get(o:DisplayObjectContainer, name:String):DisplayObject return untyped o[name];
	
	//inline public static function button(o:DisplayObjectContainer, name:String):ButtonCore return getTyped(o, name, Button).core;
	
}