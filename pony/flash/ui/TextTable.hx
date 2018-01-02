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
package pony.flash.ui;

import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.text.TextField;
import flash.text.TextFormat;
import pony.color.Color;
import pony.color.UColor;
import pony.geom.Point.IntPoint;
import pony.geom.Rect.IntRect;
import pony.ui.gui.FontStyle;
import pony.ui.gui.TextTableCore;

/**
 * Table
 * @author AxGord <axgord@gmail.com>
 */
class TextTable extends TextTableCore {

	private var area:DisplayObjectContainer;
	private var shape:Shape;
	private var g(get,never):Graphics;
	
	public function new(area:DisplayObjectContainer) {
		super();
		this.area = area;
		createShape();
	}
	
	inline private function createShape():Void {
		shape = new Shape();
		area.addChild(shape);
	}
	
	private inline function get_g():Graphics return shape.graphics;

	override private function drawBG(r:IntRect, color:UColor):Void {
		g.lineStyle();
		g.beginFill(color);
		g.drawRect(r.getX(), r.getY(), r.getWidth(), r.getHeight());
		g.endFill();
	}
	
	override private function drawText(point:IntRect, text:String, style:FontStyle):Void {
		var tf = new TextField();
		tf.text = text;
		trace(style);
		tf.selectable = false;
		tf.setTextFormat(new TextFormat(style.font, style.size, style.color, style.bold, style.italic, style.underline));
		tf.x = point.x;
		tf.y = point.y;
		area.addChild(tf);
	}
	
	override private function clear():Void {
		area.removeChild(shape);
		createShape();
	}
	
}