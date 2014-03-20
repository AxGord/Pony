/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.unity3d.ui;

import cs.NativeArray.NativeArray;
import pony.events.Event;
import pony.unity3d.ui.TintButton;
import unityengine.Texture;
import pony.ui.ButtonCore;

using hugs.HUGSWrapper;

/**
 * TextureButton
 * @author AxGord <axgord@gmail.com>
 */
class TextureButton extends TintButton {

	private var defs:NativeArray<Texture>;
	private var overs:NativeArray<Texture>;
	private var press:NativeArray<Texture>;
	
	override function Start():Void {
		
		for (i in 0...overs.Length) if (overs[i] != null) {
			core.changeVisual.sub(Focus, i).add(txset.bind(overs[i]));
			core.changeVisual.sub(Leave, i).add(txset.bind(overs[i]));
		}
		
		for (i in 0...press.Length) if (press[i] != null)
			core.changeVisual.sub(Press, i).add(txset.bind(press[i]));
			
		
		if (defs.Length == 0) {
			core.changeVisual.sub(Default, 0).add(txset.bind(guiTexture.texture));
			core.changeVisual.sub(Focus, 0).add(_txset.bind(guiTexture.texture));
			core.changeVisual.sub(Leave, 0).add(_txset.bind(guiTexture.texture));
			core.changeVisual.sub(Press, 0).add(_txset.bind(guiTexture.texture));
		} else {
			defs[0] = guiTexture.texture;	
			for (i in 0...defs.Length) if (defs[i] != null) {
				core.changeVisual.sub(Default, i).add(txset.bind(defs[i]));
				core.changeVisual.sub(Focus, i).add(_txset.bind(defs[i]));
				core.changeVisual.sub(Leave, i).add(_txset.bind(defs[i]));
				core.changeVisual.sub(Press, i).add(_txset.bind(defs[i]));
			}
		}
		
		super.Start();
	}
	
	private function txset(t:Texture, e:Event):Void {
		restoreColor();
		guiTexture.texture = t;
		e.stopPropagation();
	}
	
	private function _txset(t:Texture):Void {
		guiTexture.texture = t;
	}
	
}