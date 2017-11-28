/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
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