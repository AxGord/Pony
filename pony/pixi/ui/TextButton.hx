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
package pony.pixi.ui;

import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;
import pixi.extras.BitmapText.BitmapTextStyle;
import pony.color.UColor;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.pixi.Touchable;

/**
 * TextButton
 * @author AxGord <axgord@gmail.com>
 */
class TextButton extends Sprite implements IWH {

	public var core:ButtonImgN;
	public var text(get, set):String;
	public var btext(default, null):BText;
	public var size(get, never):Point<Float>;
	private var color:Array<UColor>;
	
	public function new(color:Array<UColor>, text:String, font:String, ?ansi:String) {
		super();
		this.color = color;
		btext = new BText(text, {font: font, tint: color[0]}, ansi);
		addChild(btext);
		var g = new Graphics();
		g.lineStyle();
		g.beginFill(0, 0);
		g.drawRect(0, 0, size.x, size.y);
		g.endFill();
		addChildAt(g, 0);
		g.buttonMode = true;
		core = new ButtonImgN(new Touchable(g));
		core.onImg << imgHandler;
	}
	
	private function imgHandler(n:Int):Void {
		n--;
		if (n > color.length) n = color.length - 1;
		btext.tint = color[n];
	}
	
	@:extern inline private function get_text():String return btext.text;
	
	@:extern inline private function set_text(t:String):String {
		btext.setText(t);
		return t;
	}
	
	inline private function get_size():Point<Float> {
		return btext.size;
	}
	
	inline public function wait(cb:Void->Void):Void btext.wait(cb);
	
}