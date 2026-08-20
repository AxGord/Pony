package pony.openfl.ui;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.text.TextField;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ui.gui.BaseLayoutCore;

/**
 * BaseLayout
 * @author meerfolk<meerfolk@gmail.com>
 */
class BaseLayout<T:BaseLayoutCore<DisplayObject>> extends Sprite implements IWH {

	public var layout(default, null): T;

	public var size(get, never): Point<Float>;

	public function new() {
		super();
		layout.load = load;
		layout.getSize = getSize;
		layout.setXpos = setXpos;
		layout.setYpos = setYpos;
	}

	private inline function get_size(): Point<Float> return layout.size;

	public function add(obj: DisplayObject): Void {
		addChild(obj);
		layout.add(obj);
	}

	public function wait(cb: Void -> Void): Void layout.wait(cb);

	public function destroy(): Void {
		layout.destroy();
		// super.destroy();
	}

	private function load(obj: DisplayObject): Void {
		if (!Std.is(obj, Sprite)) return;
		layout.tasks.add();
		layout.tasks.end();
	}

	private function destroyChild(obj: DisplayObject): Void {
		if (!Std.is(obj, DisplayObject)) return;
		var s: DisplayObject = cast obj;
		removeChild(s);
	}

	private function setXpos(obj: DisplayObject, v: Float): Void obj.x = v;

	private function setYpos(obj: DisplayObject, v: Float): Void obj.y = v;

	private function getSize(o: DisplayObject): Point<Float> {
		// return if (Std.is(o, TextField))
		// 	new Point(untyped o.textWidth, untyped o.textHeight);
		// else
		// 	new Point(o.width, o.height);
		return new Point(o.width, o.height);
	}

	private static function getSizeMod(o: DisplayObject, p: Point<Float>): Point<Float> return new Point(p.x * o.scaleX, p.y * o.scaleY);

}
