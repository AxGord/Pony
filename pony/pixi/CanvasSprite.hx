/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import pixi.core.renderers.canvas.CanvasRenderer;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;
import pony.geom.Point;
import pony.time.DeltaTime;

/**
 * CanvasSprite
 * @author AxGord <axgord@gmail.com>
 */
class CanvasSprite extends Sprite {
	
	private static var _renderer:CanvasRenderer;
	
	private static var inited:Bool = false;
	
	private static function init():Void {
		if (inited) return;
		inited == true;
		if (JsTools.isIE) return;
		_renderer = new CanvasRenderer(0, 0);
	}
	
	public var result:Sprite;
	private var txtr:RenderTexture;
	
	public function new(sourse:Sprite, size:Point<Int>, ?offset:Point<Int>) {
		super();
		init();
		if (_renderer == null) {
			result = sourse;
			return;
		}
		if (offset != null) {
			sourse.x = offset.x;
			sourse.y = offset.y;
		}
		addChild(sourse);
		txtr = new RenderTexture(_renderer, size.x, size.y);
		result = new Sprite(txtr);
		if (offset != null) {
			result.x = -offset.x;
			result.y = -offset.y;
		}
	}
	
	public function needRenderer():Void if (_renderer != null) DeltaTime.fixedUpdate < render;
	
	private function render():Void {
		visible = true;
		txtr.render(this, null, true, true);
		txtr.update();
		visible = false;
	}
	
}