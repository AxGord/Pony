/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
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