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
package pony.unity3d.ui;

import pony.events.Event;
import pony.ui.gui.ButtonCore;
import unityengine.Color;
import unityengine.Texture;
import unityengine.GameObject;

/**
 * Tint Button
 * This button use tint effect for over and press.
 * @see Button
 * @see pony.ui.ButtonCore
 * @author AxGord
 */
@:nativeGen class TintButton extends Button {

	private var tint:Single = 0.2;
	
	@:meta(UnityEngine.HideInInspector)
	private var sclr:Color;
	
	override function Start():Void {
		super.Start();
		sclr = guiTexture.color;
		
		core.changeVisual.sub(Focus, 1).add(cancle);
		core.changeVisual.sub(Leave, 1).add(cancle);
		core.changeVisual.sub(Press, 1).add(cancle);
		core.changeVisual.sub(Default, 1).add(cancle);
		
		core.changeVisual.sub(Focus).add(tfocus);
		core.changeVisual.sub(Leave).add(tleave);
		core.changeVisual.sub(Press).add(tpress);
		core.changeVisual.sub(Default).add(restoreColor);
		
		core.sendVisual();
	}
	
	private function tfocus():Void guiTexture.color = new Color(sclr.r + tint, sclr.g + tint, sclr.b + tint);
	private function tpress():Void guiTexture.color = new Color(sclr.r - tint, sclr.g - tint, sclr.b - tint);
	private function tleave():Void guiTexture.color = new Color(sclr.r - tint / 2, sclr.g - tint / 2, sclr.b - tint / 2);
	private function restoreColor():Void guiTexture.color = new Color(sclr.r, sclr.g, sclr.b);
	
	private function cancle(e:Event):Void {
		restoreColor();
		e.stopPropagation();
	}
	
}