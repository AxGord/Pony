package pony.pixi.ui;

import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.extras.BitmapText;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ui.gui.BaseLayoutCore;

using pony.pixi.PixiExtends;

/**
 * BaseLayout
 * @author AxGord <axgord@gmail.com>
 */
class BaseLayout<T:BaseLayoutCore<Container>> extends Sprite implements IWH {

	public var layout(default, null): T;

	public var size(get, never): Point<Float>;

	public function new() {
		super();
		layout.load = load;
		layout.getSize = getSize;
		layout.getSizeMod = getSizeMod;
		layout.setXpos = setXpos;
		layout.setYpos = setYpos;
	}

	private inline function get_size(): Point<Float> return visible ? layout.size : new Point<Float>(0, 0);

	public function add(obj: Container): Void {
		addChild(obj);
		layout.add(obj);
	}

	public function addAt(obj: Container, index: Int): Void {
		addChildAt(obj, index);
		layout.addAt(obj, index);
	}

	public function addToBegin(obj: Container): Void {
		addChildAt(obj, 0);
		layout.addToBegin(obj);
	}

	public function remove(obj: Container): Void {
		removeChild(obj);
		layout.remove(obj);
	}

	public function wait(cb: Void -> Void): Void layout.wait(cb);

	override public function destroy(?options: haxe.extern.EitherType<Bool, DestroyOptions>): Void {
		layout.destroy();
		layout = null;
		super.destroy(options);
	}

	public function destroyIWH(): Void destroy();

	private function load(obj: Container): Void {
		if (!Std.is(obj, Sprite)) return;
		layout.tasks.add();
		cast(obj, Sprite).loaded(layout.tasks.end);
	}

	private function destroyChild(obj: Container): Void {
		if (!Std.is(obj, DisplayObject)) return;
		final s: DisplayObject = cast obj;
		removeChild(s);
		s.destroy();
	}

	private function setXpos(obj: Container, v: Float): Void obj.x = v;

	private function setYpos(obj: Container, v: Float): Void obj.y = v;

	private function getSize(o: Container): Point<Float> {
		return Std.is(o, BitmapText)
			? new Point(untyped o.textWidth, untyped o.textHeight)
			: new Point(o.width * o.scale.x, o.height * o.scale.y);
	}

	private static function getSizeMod(o: Container, p: Point<Float>): Point<Float>
		return p == null ? null : new Point(p.x * o.scale.x, p.y * o.scale.y);

}
