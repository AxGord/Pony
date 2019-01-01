package pony.openfl.ui;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.text.TextField;
import pony.ui.gui.BaseLayoutCore;
import pony.geom.IWH;
import pony.geom.Point;

/**
 * BaseLayout
 * @author meerfolk<meerfolk@gmail.com>
 */
class BaseLayout<T:BaseLayoutCore<DisplayObject>> extends Sprite implements IWH {
	
	public var layout(default, null):T;
	public var size(get, never):Point<Float>;
	
	public function new() {
		super();
		layout.load = load;
		layout.getSize = getSize;
		layout.setXpos = setXpos;
		layout.setYpos = setYpos;
	}
	
	public function add(obj:DisplayObject):Void {
		addChild(obj);
		layout.add(obj);
	}
	
	private function load(obj : DisplayObject) : Void {
		if (Std.is(obj, Sprite)) {
			layout.tasks.add();
			layout.tasks.end();
		}
	}
	
	private function destroyChild(obj:DisplayObject):Void {
		if (Std.is(obj, DisplayObject)) {
			var s:DisplayObject = cast obj;
			removeChild(s);
			s = null;
		}
	}
	
	private function setXpos(obj:DisplayObject, v:Float):Void obj.x = v;
	private function setYpos(obj:DisplayObject, v:Float):Void obj.y = v;
	
	public function wait(cb:Void->Void):Void layout.wait(cb);
	
	private function getSize(o:DisplayObject):Point<Float> {
		/*
		return if (Std.is(o, TextField))
			new Point(untyped o.textWidth, untyped o.textHeight);
		else
			new Point(o.width, o.height);
			*/
		return new Point(o.width, o.height);
	}
	
	private static function getSizeMod(o:DisplayObject, p:Point<Float>):Point<Float> return new Point(p.x * o.scaleX, p.y * o.scaleY);
	
	inline private function get_size():Point<Float> return layout.size;
	
	public function destroy():Void {
		layout.destroy();
		//super.destroy();
	}
	
	
}