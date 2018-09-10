/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import pixi.core.sprites.Sprite;
import pixi.core.display.DisplayObject;
import pixi.core.textures.Texture;

import js.html.CanvasElement;
import js.Browser;

import pony.pixi.App;
import pony.geom.IWH;
import pony.geom.Point;
import pony.color.UColors;
import pony.magic.HasLink;

class Gradient extends Sprite implements IWH implements HasLink {

	public var size(link, never):Point<Float> = _size;

	private var _size:Point<Float>;

	public function new(size:Point<Float>, colors:UColors, isVert:Bool = false, ?app:App) {
		if (app == null) app = App.main;
		_size = size;
		var canvas:CanvasElement = Browser.document.createCanvasElement();
		var ctx = canvas.getContext2d();
		var l:Int = colors.length;
		if (isVert) {
			canvas.width = 1;
			canvas.height = l;
			for (i in 0...l) {
				ctx.fillStyle = colors[i];
				ctx.fillRect(0, i, 1, 1);
			}
		} else {
			canvas.width = l;
			canvas.height = 1;
			for (i in 0...l) {
				ctx.fillStyle = colors[i];
				ctx.fillRect(i, 0, 1, 1);
			}
		}
		super(Texture.fromCanvas(canvas));
		if (isVert)
			scale.set(size.x, size.y / l);
		else
			scale.set(size.x / l, size.y);
	}

	public function wait(fn:Void -> Void):Void fn();

	public function destroyIWH():Void destroy();

}