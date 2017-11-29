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

import js.html.CSSStyleDeclaration;
import pixi.core.display.DisplayObject;
import pony.pixi.HtmlContainerBase;
import pony.geom.Rect;
import pony.geom.Point;
using pony.pixi.PixiExtends;

class HtmlContainer extends pixi.core.sprites.Sprite implements pony.geom.IWH {

	public var element:js.html.Element;
	public var size(get, never):Point<Float>;
	public var targetStyle(get, set):CSSStyleDeclaration;

	private var htmlContainer:HtmlContainerBase;
	private var targetRect(get, set):Rect<Float>;
	private var _size:Point<Float>;

	public function new(targetRect:Rect<Float>, ?app:pony.pixi.App) {
		super();
		//var g = new pixi.core.graphics.Graphics();
		//g.beginFill(0x0);
		//g.drawRect(0, 0, targetRect.width, targetRect.height);
		//addChild(g);
		_size = new Point(targetRect.width, targetRect.height);
		htmlContainer = new HtmlContainerBase(targetRect, app);
		pony.time.DeltaTime.fixedUpdate < posUpdate;
		pony.time.DeltaTime.skipUpdate(posUpdate);
	}

	public function wait(f:Void -> Void):Void f();

	public function posUpdate():Void {
		var gx:Float = 0;
		var gy:Float = 0;
		var p:DisplayObject = parent;
		while (p.parent.parent != null) {
			gx += p.x;
			gy += p.y;
			p = p.parent;
		}
		htmlContainer.targetPos = new Point(gx, gy);
	}
	
	@:extern private inline function get_targetStyle():CSSStyleDeclaration return htmlContainer.targetStyle;
	@:extern private inline function set_targetStyle(v:CSSStyleDeclaration):CSSStyleDeclaration return htmlContainer.targetStyle = v;
	@:extern private inline function get_targetRect():Rect<Float> return htmlContainer.targetRect;
	@:extern private inline function set_targetRect(r:Rect<Float>):Rect<Float> return htmlContainer.targetRect = r;
	@:extern private inline function get_size():Point<Float> return _size;

	public function destroyIWH():Void destroy();

}