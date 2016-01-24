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
package pony.pixijs.ui;

import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pony.geom.Border;
import pony.pixijs.ETextStyle;
import pony.pixijs.UniversalText;
import pony.time.DeltaTime;
import pony.ui.gui.RubberLayoutCore;

using pony.pixijs.PixijsExtends;

/**
 * TextBox
 * @author AxGord <axgord@gmail.com>
 */
class TextBox extends BaseLayout<RubberLayoutCore<Container>> {

	public var text(get, set):String;
	
	public var obj(default, null):UniversalText;
	
	public function new(image:Sprite, text:String, style:ETextStyle, ?border:Border<Int>) {
		layout = new RubberLayoutCore(border);
		layout.tasks.add();
		super();
		addChild(image);
		image.loaded(function(){
			layout.width = image.width;
			layout.height = image.height;
			layout.tasks.end();
		});
		add(obj = new UniversalText(text, style));
	}
	
	inline private function get_text():String return obj.text;
	
	private function set_text(v:String):String {
		if (obj.text != v) {
			obj.text = v;
			update();
		}
		return v;
	}
	
	@:extern inline private function update():Void {
		layout.update();
		_update();
		DeltaTime.fixedUpdate < _update;
	}
	
	inline private function _update():Void {
		DeltaTime.fixedUpdate < layout.update;
	}
	
}