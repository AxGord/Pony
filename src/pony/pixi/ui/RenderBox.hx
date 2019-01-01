package pony.pixi.ui;

import pixi.core.textures.RenderTexture;
import pixi.core.textures.Texture;
import pixi.core.display.DisplayObject;
import pixi.core.renderers.canvas.CanvasRenderer;
import pony.pixi.App;
import pony.geom.Point;

/**
 * RenderBox
 * @author AxGord <axgord@gmail.com>
 */
class RenderBox extends pixi.core.sprites.Sprite implements pony.geom.IWH {

	public var size(get, never):Point<Float>;

	private var container:RenderContainer;
	private var renderTexture:RenderTexture;
	private var app:App;

	public function new(w:Float, h:Float, ?app:App, ?canvas:Bool) {
		this.app = app == null ? App.main : app;
		if (!canvas)
			renderTexture = RenderTexture.create(w, h);
		super(renderTexture);
		container = new RenderContainer(new Point(w, h));
	}

	public function update():Void {
		if (renderTexture != null) {
			app.app.renderer.render(container, renderTexture, true);
		} else {
			var _renderer = new CanvasRenderer(size.x, size.y);
			_renderer.clearBeforeRender = true;
			_renderer.transparent = true;
			_renderer.render(container);
			texture = Texture.fromCanvas(_renderer.view);
		}
	}

	@:extern public inline function addElement(obj:DisplayObject):Void container.addChild(obj);

	@:extern private inline function get_size():Point<Float> return container.size;

	public function wait(f:Void -> Void):Void container.wait(f);

	public function destroyIWH():Void {
		container.destroyIWH();
		destroy();
	}

}

class RenderContainer extends pixi.core.sprites.Sprite implements pony.geom.IWH {

	public var size(get, never):Point<Float>;

	private var _size:Point<Float>;

	public function new(size:Point<Float>) {
		super();
		_size = size;
	}

	@:extern private inline function get_size():Point<Float> return _size;

	public function wait(f:Void -> Void):Void f();

	public function destroyIWH():Void destroy();

}