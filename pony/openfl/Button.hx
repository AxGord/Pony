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
package pony.openfl;

import openfl.display.Sprite;
import pony.ui.touch.Touchable;
import pony.ui.gui.ButtonImgN;

/**
 * Button
 * @author AxGord <axgord@gmail.com>
 */
class Button extends Sprite {

	public var core(default, null):ButtonImgN;
	
	private var states:Array<SBitmap>;
	private var zone:SBitmap;
	
	public function new(states:Array<String>) {
		super();
		var created:Map<String, SBitmap> = new Map();
		this.states = [for (s in states) {
			if (s == null) null;
			else if (created.exists(s)) created[s];
			else {
				var b = new SBitmap(s);
				addChild(b);
				b.visible = false;
				created[s] = b;
			}
		}];
		this.states[0].visible = true;
		if (this.states.length > 3) {
			zone = this.states[3] == null ? new SBitmap(states[0]) : this.states[3];
			this.states.splice(3, 1);
		} else {
			zone = new SBitmap(states[0]);
		}
		var z = new Sprite();
		z.addChild(zone);
		z.alpha = 0;
		z.buttonMode = true;
		addChild(z);
		core = new ButtonImgN(new Touchable(z));
		core.onImg << change;
		
	}
	
	private function change(img:Int):Void {
		img--;
		for (b in states) if (b != null) b.visible = false;
		if (img == 3 && states[img] == null) {
			zone.visible = false;
			return;
		} else {
			zone.visible = true;
		}
		if (img >= states.length) img = states.length - 1;
		while (states[img] == null) img--;
		states[img].visible = true;
	}
	
}