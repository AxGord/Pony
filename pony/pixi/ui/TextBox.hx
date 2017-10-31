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

import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pixi.extras.BitmapText.BitmapTextStyle;
import pony.geom.Border;
import pony.pixi.ETextStyle;
import pony.pixi.UniversalText;
import pony.time.DeltaTime;
import pony.ui.gui.RubberLayoutCore;

using pony.pixi.PixiExtends;

/**
 * TextBox
 * @author AxGord <axgord@gmail.com>
 */
class TextBox extends BaseLayout<RubberLayoutCore<Container>> {

	public var text(get, set):String;
	public var obj(default, null):BText;
	
	private var nocache:Bool;
	
	public function new(image:Sprite, text:String, style:ETextStyle, ?ansi:String, ?border:Border<Int>, nocache:Bool = false, shadow:Bool = false) {
		this.nocache = nocache;
		layout = new RubberLayoutCore(border);
		layout.tasks.add();
		super();
		addChild(image);
		image.loaded(function(){
			layout.width = image.width;
			layout.height = image.height;
			layout.tasks.end();
		});
		switch style {
			case ETextStyle.BITMAP_TEXT_STYLE(s):
				add(obj = new BText(text, s, ansi, shadow));
			case _:
				throw 'Not supported';
		}
	}
	
	inline private function get_text():String return obj.t;
	
	private function set_text(v:String):String {
		if (v != obj.t) {
			obj.t = v;
			layout.update();
		}
		return v;
	}
	
}