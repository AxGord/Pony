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

import pony.geom.Border;
import pony.geom.Point;
import pony.pixi.ui.TextSizedBox;

/**
 * LabelBar
 * @author AxGord <axgord@gmail.com>
 */
class LabelBar extends AnimBar {

	public var text(get, set):String;
	
	private var label:TextSizedBox;
	private var style:ETextStyle;
	private var labelInitVisible:Bool = true;
	private var border:Border<Int>;
	
	public function new(
		bg:String,
		fillBegin:String,
		fill:String,
		?animation:String,
		animationSpeed:Int = 2000,
		?border:Border<Int>,
		?style:ETextStyle,
		invert:Bool = false
	) {
		this.style = style;
		this.border = border;
		super(bg, fillBegin, fill, animation, animationSpeed, border == null ? null : new Point(border.left, border.top), invert);
		onReady < readyHandler;
	}
	
	private function readyHandler(p:Point<Int>):Void {
		label = new TextSizedBox(p.x, p.y, '', style, border, true);
		label.visible = labelInitVisible;
		addChild(label);
		style = null;
	}
	
	@:extern inline function get_text():String return label.text;
	@:extern inline function set_text(s:String):String return label.text = s;

	override public function startAnimation():Void {
		if (label == null)
			labelInitVisible = false;
		else
			label.visible = false;
		super.startAnimation();
	}
	
	override public function stopAnimation():Void {
		if (label == null)
			labelInitVisible = true;
		else
			label.visible = true;
		super.stopAnimation();
	}
	
	override public function destroy():Void {
		border = null;
		style = null;
		if (label != null) {
			label.destroy();
			label = null;
		}
		super.destroy();
	}
	
}