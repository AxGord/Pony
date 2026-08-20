package pony.pixi.ui;

import js.Browser;
import js.html.CanvasElement;
import pixi.core.display.DisplayObject;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pony.color.UColor;
import pony.color.UColors;
import pony.geom.IWH;
import pony.geom.Point;
import pony.magic.HasLink;
import pony.pixi.App;

/**
 * Gradient
 * @author AxGord <axgord@gmail.com>
 */
class Gradient extends Sprite implements IWH implements HasLink {

	public var size(link, never): Point<Float> = _size;

	private final _size: Point<Float>;

	public function new(size: Point<Float>, colors: UColors, isVert: Bool = false, ?app: App) {
		if (app == null) app = App.main;
		_size = size;
		var canvas: CanvasElement = Browser.document.createCanvasElement();
		final ctx = canvas.getContext2d();
		final l: Int = colors.length;
		if (isVert) {
			canvas.width = 1;
			canvas.height = l;
			for (i in 0...l) {
				ctx.fillStyle = colors[i].toRGBAIString();
				ctx.fillRect(0, i, 1, 1);
			}
		} else {
			canvas.width = l;
			canvas.height = 1;
			for (i in 0...l) {
				ctx.fillStyle = colors[i].toRGBAIString();
				ctx.fillRect(i, 0, 1, 1);
			}
		}
		super(Texture.fromCanvas(canvas));
		if (isVert)
			scale.set(size.x, size.y / l);
		else
			scale.set(size.x / l, size.y);
	}

	public function wait(fn: Void -> Void): Void fn();

	public function destroyIWH(): Void destroy();

}
