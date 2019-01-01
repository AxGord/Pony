package pony.pixi;

import js.Browser;
import pixi.core.Pixi;
import pixi.core.renderers.canvas.CanvasRenderer;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;
import pixi.core.textures.Texture;
import pony.JsTools;
import pony.geom.Point;
import pony.time.DeltaTime;

/**
 * CanvasSprite
 * @author AxGord <axgord@gmail.com>
 */
class CanvasSprite extends Sprite {
	
	private var sourse:Sprite;
	private var size:Point<Int>;
	private var offset:Point<Int>;
	
	public function new(sourse:Sprite, size:Point<Int>, ?offset:Point<Int>) {
		super();
		this.size = size;
		this.sourse = sourse;
		this.offset = offset;
		if (JsTools.agent == IE) {
			addChild(sourse);
			return;
		}
		if (offset != null) {
			sourse.x = offset.x;
			sourse.y = offset.y;
		}
	}
	
	public function needRenderer():Void if (JsTools.agent != IE) DeltaTime.fixedUpdate < render;
	
	private function render():Void {
		if (children.length > 0) {
			var sp = children[0];
			removeChildAt(0);
			sp.destroy(true);
		}
		addChild(sourse);
		
		var _renderer = new CanvasRenderer(size.x, size.y);
		_renderer.transparent = true;
		_renderer.render(this);
		
		removeChildAt(0);
		var result = new Sprite(Texture.fromCanvas(_renderer.view));
		if (offset != null) {
			result.x = -offset.x;
			result.y = -offset.y;
		}
		addChild(result);
		_renderer.destroy();
	}
	
}