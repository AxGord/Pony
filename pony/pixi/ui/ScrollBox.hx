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

import pixi.core.Pixi;
import pixi.core.graphics.Graphics;
import pixi.core.display.DisplayObject;
import pixi.core.sprites.Sprite;
import pony.Or;
import pony.events.Signal1;
import pony.events.WaitReady;
import pony.geom.IWH;
import pony.geom.Point;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.ui.gui.SmoothBarCore;
import pony.ui.touch.Touchable;

using pony.pixi.PixiExtends;

/**
 * ScrollBox
 * @author AxGord <axgord@gmail.com>
 */
class ScrollBox extends Sprite implements HasSignal implements IWH {
	
	public var size(get, never):Point<Float>;

	private var _size:Point<Float>;
	private var vert:Bool;
	private var bar:Graphics;
	private var content:Sprite = new Sprite();
	private var touchable:Touchable;

	public function new(w:Float, h:Float, vert:Bool = true, color:UInt = 0, barsize:Float = 8) {
		if (!vert) throw 'Not supported!';
		super();
		_size = new Point(w, h);
		this.vert = vert;
		var g = new Graphics();
		g.beginFill(0x606060);
		if (vert)
			g.drawRect(0, 0, w - barsize, h);
		else
			g.drawRect(0, 0, w, h - barsize);
		touchable = new Touchable(g);
		touchable.onWheel << wheelHandler;
		addChild(g);
		bar = new Graphics();
		bar.beginFill(color);
		if (vert) {
			bar.drawRect(w - barsize, 0, barsize, 1);
		} else {
			bar.drawRect(0, h - barsize, 1, barsize);
		}
		addChild(bar);
		addChild(content);
		content.mask = g;
	}

	private function wheelHandler(delta:Int):Void {
		var csize:Float = content.getBounds().height;
		content.y += delta;
		if (content.y < -csize + size.y) {
			content.y = -csize + size.y;
		} else if (content.y > 0) {
			content.y = 0;
		}

		bar.y = -content.y;
	}

	public function add(c:DisplayObject):Void {
		content.addChild(c);
		needUpdate();
	}

	public function needUpdate():Void {
		DeltaTime.fixedUpdate < update;
	}

	public function update():Void {
		var b = content.getLocalBounds();
		if (b.height <= size.y) {
			bar.visible = false;
		} else {
			bar.visible = true;
			bar.height = size.y * 2 - b.height;
		}
	}

	private function get_size():Point<Float> return _size;

	public function wait(fn:Void -> Void):Void fn();

	public function destroyIWH():Void destroy();

}