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
package pony.ui.xml;

import pixi.core.display.DisplayObject;
import pixi.core.sprites.Sprite;
import pixi.extras.BitmapText;
import pony.color.UColor;
import pony.magic.HasAbstract;
import pony.pixi.ui.IntervalLayout;

/**
 * PixiXmlUi
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.ui.xml.XmlUiBuilder.build({
	free: pixi.core.sprites.Sprite,
	image: pixi.core.sprites.Sprite,
	text: pixi.extras.BitmapText,
	ivlayout: pony.pixi.ui.IntervalLayout,
	ihlayout: pony.pixi.ui.IntervalLayout
}))
#end
class PixiXmlUi extends Sprite implements HasAbstract {

	private function createUIElement(name:String, attrs:Dynamic<String>, content:Array<Dynamic>):Dynamic {
		var obj:DisplayObject = switch name {
			case 'free':
				var s = new Sprite();
				for (e in content) s.addChild(e);
				s;
			case 'image':
				Sprite.fromImage(attrs.src);
			case 'text':
				var font = attrs.size + 'px ' + attrs.font;
				var text = content.length > 0 ? content[0] : '';
				new BitmapText(text, {font: font, tint: UColor.fromString(attrs.color).rgb});
			case 'ivlayout':
				var l = new IntervalLayout(Std.parseInt(attrs.i), true);
				for (e in content) l.add(e);
				l;
			case 'ihlayout':
				var l = new IntervalLayout(Std.parseInt(attrs.i), false);
				for (e in content) l.add(e);
				l;
			case _:
				throw 'Unknown component $name';
		}
		if (attrs.x != null) obj.x = Std.parseInt(attrs.x);
		if (attrs.y != null) obj.y = Std.parseInt(attrs.y);
		return obj;
	}
	
	@:abstract private function _createUI():DisplayObject;
	
	private function createUI():Void addChild(_createUI());
	
}