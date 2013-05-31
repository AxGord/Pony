package pony.flash;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;
import pony.events.Signal;
import pony.Rect;

/**
 * ...
 * @author AxGord
 */

typedef Sigid = {d:EventDispatcher, n:String};
 
class FLExtends {
	
	private static var signals:Map<Sigid, Signal> = new Map<Sigid, Signal>();
	
	public static function buildSignal(d:EventDispatcher, name:String):Signal {
		var sid:Sigid = { d:d, n:name };
		var s:Signal;
		if (!signals.exists(sid)) signals.set(sid, s = new Signal());
		else s = signals.get(sid);
		d.addEventListener(name, function(event:Event) s.dispatchArgs([event]));
		return s;
	}
	
	public inline static function v(f:Void->Void):Dynamic return function(Void) f();
	
	public static function childrens(d:DisplayObjectContainer):Iterator<DisplayObject> {
		var it:IntIterator = 0...d.numChildren;
		return {
			hasNext: it.hasNext,
			next: function():DisplayObject return d.getChildAt(it.next())
		};
	}
	
	public static function rect(r:Rectangle):Rect<Float> return { x: r.x, y: r.y, width: r.width, height: r.height };
	
}