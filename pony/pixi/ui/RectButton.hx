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

import pixi.core.math.shapes.Rectangle;
import pixi.core.graphics.Graphics;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject.DestroyOptions;
import pony.ui.gui.RubberLayoutCore;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.Touchable;
import pony.geom.Border;
import pony.geom.Point;
import pony.color.UColor;

/**
 * RectButton
 * @author AxGord <axgord@gmail.com>
 */
class RectButton extends BaseLayout<RubberLayoutCore<Container>> {

	public var core(default, null):ButtonImgN;
	public var touchActive(get, set):Bool;
	public var cursor(get, set):Bool;

	private var g:Graphics = new Graphics();
	private var colors:Array<UColor>;

	public function new(size:Point<Int>, colors:Array<UColor>, vert:Bool = false, ?border:Border<Int>, ?offset:Point<Float>) {
		this.colors = colors;
		layout = new RubberLayoutCore<Container>(vert, border);
		layout.width = size.x;
		layout.height = size.y;
		super();
		core = new ButtonImgN(new Touchable(g));
		core.onImg << imgHandler;
		core.onDisable << disableHandler;
		core.onEnable << enableHandler;
		addChild(g);
		imgHandler(1);
		cursor = true;
	}

	private function imgHandler(n:Int):Void {
		if (n == 4) {
			visible = false;
			return;
		} else {
			visible = true;
			g.clear();
			if (n > colors.length) n = colors.length;
			g.beginFill(colors[n - 1].rgb, colors[n - 1].invertAlpha.af);
			g.drawRect(0, 0, layout.size.x, layout.size.y);
		}
	}
	
	override public function add(obj:Container):Void {
		obj.interactive = false;
		obj.interactiveChildren = false;
		obj.hitArea = new Rectangle(0, 0, 0, 0);
		super.add(obj);
	}
	
	private function disableHandler():Void cursor = false;
	private function enableHandler():Void cursor = true;
	inline private function get_cursor():Bool return g.buttonMode;
	inline private function set_cursor(v:Bool):Bool return g.buttonMode = v;
	inline private function get_touchActive():Bool return g.interactive;
	inline private function set_touchActive(v:Bool):Bool return g.interactive = v;

	override function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		core.destroy();
		core = null;
		removeChild(g);
		g.destroy();
		g = null;
		layout.destroy();
		layout = null;
		super.destroy(options);
	}

}