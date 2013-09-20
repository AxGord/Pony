/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import pony.events.Event;
import pony.ui.ButtonCore;
import unityengine.Color;
import unityengine.Texture;

/**
 * Tint Button
 * This button use tint effect or textures for over, out and click.
 * @see Button
 * @see pony.ui.ButtonCore
 * @author AxGord
 */
class TintButton extends Button {

	private var tint:Single = 0.2;
	private var pressedTexture:Texture;
	private var secondState:Texture;
	private var defaultTexture:Texture;
	private var sclr:Color;
	
	override function Start() {
		super.Start();
		defaultTexture = guiTexture.texture;
		sclr = guiTexture.color;
		core.changeVisual.add(change);
		core.sendVisual();
	}
	
	function change(event:Event) {
		if (event.args[1] == 1) {
			if (pressedTexture != null) {
				guiTexture.texture = pressedTexture;
				guiTexture.color = sclr;
			} else
				guiTexture.color = new Color(sclr.r - tint / 2, sclr.g - tint / 2, sclr.b - tint / 2);
			return;
		}
		
		if (event.args[1] == 2 && secondState != null) 
			guiTexture.texture = secondState;
		else if (pressedTexture != null || secondState != null) {
			guiTexture.texture = defaultTexture;
		}
		switch (cast(event.args[0], ButtonStates)) {
			case ButtonStates.Focus | ButtonStates.Leave:
				guiTexture.color = new Color(sclr.r + tint, sclr.g + tint, sclr.b + tint);
			case ButtonStates.Default:
				guiTexture.color = sclr;
			case ButtonStates.Press:
				if (pressedTexture != null) {
					guiTexture.texture = pressedTexture;
					guiTexture.color = new Color(sclr.r - tint / 2, sclr.g - tint / 2, sclr.b - tint / 2);
					
				} else
					guiTexture.color = new Color(sclr.r - tint, sclr.g - tint, sclr.b - tint);
		}
	}
	
}