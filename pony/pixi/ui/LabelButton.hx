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

import pixi.core.display.Container;
import pony.geom.Border;
import pony.geom.Point;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.RubberLayoutCore;

using pony.pixi.PixiExtends;

/**
 * LabelButton
 * @author AxGord <axgord@gmail.com>
 */
class LabelButton extends BaseLayout<RubberLayoutCore<Container>> {

	public var core(get, never):ButtonCore;
	public var button(default, null):Button;
	
	public function new(imgs:ImmutableArray<String>, vert:Bool = false, ?border:Border<Int>, ?offset:Point<Float>, useSpriteSheet:Bool=false) {
		layout = new RubberLayoutCore<Container>(vert, border);
		layout.tasks.add();
		super();
		button = new Button(imgs, offset, useSpriteSheet);
		addChild(button);
		button.wait(function() {
			layout.width = button.size.x;
			layout.height = button.size.y;
			layout.tasks.end();
		});
	}
	
	@:extern inline private function get_core():ButtonCore return button.core;
	
	override function destroy():Void {
		removeChild(button);
		button.destroy();
		button = null;
		super.destroy();
	}
	
}