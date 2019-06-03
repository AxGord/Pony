package pony.heaps.ui.gui.layout;

import h2d.Object;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ui.gui.BaseLayoutCore;

/**
 * BaseLayout
 * @author AxGord <axgord@gmail.com>
 */
class BaseLayout<T:BaseLayoutCore<Object>> extends Object implements IWH {

	public var layout(default, null):T;
	public var size(get, never):Point<Float>;

	public function new() {
		super();
		layout.getSize = _getSize;
		layout.getSizeMod = getSizeMod;
		layout.setXpos = setXpos;
		layout.setYpos = setYpos;
	}

	public function add(obj:Object):Void {
		addChild(obj);
		layout.add(obj);
	}
	
	public function addAt(obj:Object, index:Int):Void {
		addChildAt(obj, index);
		layout.addAt(obj, index);
	}
	
	public function addToBegin(obj:Object):Void {
		addChildAt(obj, 0);
		layout.addToBegin(obj);
	}

	public function rm(obj:Object):Void {
		removeChild(obj);
		layout.remove(obj);
	}

	private function setXpos(obj:Object, v:Float):Void obj.x = v;
	private function setYpos(obj:Object, v:Float):Void obj.y = v;
	
	public function wait(cb:Void -> Void):Void layout.wait(cb);
	
	private function _getSize(o:Object):Point<Float> {
		var b = o.getBounds();
		return new Point(b.width, b.height);
	}

	private static function getSizeMod(o:Object, p:Point<Float>):Point<Float> {
		return p == null ? null : new Point(p.x * o.scaleX, p.y * o.scaleY);
	}
	
	private inline function get_size():Point<Float> {
		return visible ? layout.size : new Point<Float>(0, 0);
	}
	
	public function destroyIWH():Void {
		layout.destroy();
		layout = null;
	}

}