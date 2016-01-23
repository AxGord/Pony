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

import pixi.core.textures.Texture;
import pixi.extras.MovieClip;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.Touchable;

/**
 * Button
 * @author AxGord <axgord@gmail.com>
 */
class Button extends MovieClip {

	public var core:ButtonImgN;
	private var hideDisabled:Bool;
	
	public function new(imgs:Array<String>) {
		if (imgs[0] == null) throw 'Need first img';
		if (imgs[1] == null)
			imgs[1] = imgs[2] != null ? imgs[2] : imgs[0];
		if (imgs[2] == null) imgs[2] = imgs[1];
		hideDisabled = imgs[3] == null;
		var i = 4;
		while (i < imgs.length) {
			if (imgs[i+1] == null)
				imgs[i+1] = imgs[i+2] != null ? imgs[i+2] : imgs[i];
			if (imgs[i+2] == null) imgs[i+2] = imgs[i+1];
			i += 3;
		}
		super([for (img in imgs) Texture.fromImage(img)]);
		buttonMode = true;
		core = new ButtonImgN(new Touchable(this));
		core.onImg << imgHandler;
	}
	
	private function imgHandler(n:Int):Void {
		if (n == 4 && hideDisabled) {
			visible = false;
			return;
		} else {
			visible = true;
		}
		gotoAndStop(n - 1);
	}
	
}