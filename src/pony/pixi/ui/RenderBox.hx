package pony.pixi.ui;

import pixi.core.display.DisplayObject;
import pixi.core.renderers.canvas.CanvasRenderer;
import pixi.core.textures.RenderTexture;
import pixi.core.textures.Texture;
import pony.geom.IWH;
import pony.geom.Point;
import pony.pixi.App;

/**
 * RenderBox
 * @author AxGord <axgord@gmail.com>
 */
class RenderBox extends pixi.core.sprites.Sprite implements IWH {

	public var size(get, never): Point<Float>;

	private var container: RenderContainer;
	private var renderTexture: RenderTexture;
	private var app: App;

	public function new(w: Float, h: Float, ?app: App, ?canvas: Bool) {
		this.app = app == null ? App.main : app;
		if (!canvas) renderTexture = RenderTexture.create(w, h);
		super(renderTexture);
		container = new RenderContainer(new Point(w, h));
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_size(): Point<Float> return container.size;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function addElement(obj: DisplayObject): Void container.addChild(obj);

	public function update(): Void {
		if (renderTexture != null) {
			app.app.renderer.render(container, renderTexture, true);
		} else {
			final renderer = new CanvasRenderer(size.x, size.y);
			renderer.clearBeforeRender = true;
			renderer.transparent = true;
			renderer.render(container);
			texture = Texture.fromCanvas(renderer.view);
		}
	}

	public function wait(f: Void -> Void): Void container.wait(f);

	public function destroyIWH(): Void {
		container.destroyIWH();
		destroy();
	}

}

class RenderContainer extends pixi.core.sprites.Sprite implements IWH {

	public var size(get, never): Point<Float>;

	private var _size: Point<Float>;

	public function new(size: Point<Float>) {
		super();
		_size = size;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_size(): Point<Float> return _size;

	public function wait(f: Void -> Void): Void f();

	public function destroyIWH(): Void destroy();

}
