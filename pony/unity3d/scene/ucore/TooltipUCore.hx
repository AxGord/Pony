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
package pony.unity3d.scene.ucore;

import pony.DeltaTime;
import pony.unity3d.scene.MouseHelper;
import unityengine.BoxCollider;
import unityengine.Color;
import unityengine.MonoBehaviour;
import pony.unity3d.Tooltip;
import unityengine.Texture;
import unityengine.Transform;

using hugs.HUGSWrapper;

/**
 * TooltipUCore
 * @author AxGord <axgord@gmail.com>
 * @author BoBaH6eToH
 */

class TooltipUCore extends MonoBehaviour {

	public var text:String = 'tooltip';
	public var bigText:String = '';
	public var colorMod:Color;
	public var texture:Texture;
	
	private var savedColors:Array<Color>;
	
	private var subs:Bool;
	private var subObjects:Array<Transform>;
	private var ovr:MouseHelper;
	private var lighted:Bool = false;
	
	private function Start():Void {
		if (colorMod == null || (colorMod.r == 0 && colorMod.g == 0 && colorMod.b == 0)) {
			if (Tooltip.defaultColorMod.value != null)
				colorMod = Tooltip.defaultColorMod.value;
			else
				Tooltip.defaultColorMod.add(onDCL);
		} else
			Tooltip.defaultColorMod.value = colorMod;
		if (Tooltip.texture == null) Tooltip.texture = texture;
		
		var it:NativeArrayIterator<Transform> = cast gameObject.getComponentsInChildrenOfType(Transform);
		subObjects = [for (e in it) if (e != transform && e.renderer != null) e];
		subs = subObjects.length > 0;
		
		if (!subs) {
			subObjects = [transform];
		}
		
		
		
		ovr = getOrAddTypedComponent(MouseHelper);
		ovr.over.add(over);
		ovr.out.add(out);
		ovr.middleUp.add(pressOut);
		ovr.middleDown.add(press);
		
		saveColors();
	}
	
	public function saveColors():Void {
		savedColors = [];
		for (e in subObjects) if (e.renderer.material.HasProperty('_Color'))
			savedColors.push(e.renderer.material.color);
	}
	
	private function onDCL(cl:Color):Void {
		colorMod = cl;
	}
	
	private function over():Void {
		try {
			if (MouseHelper.middleMousePressed)
				Tooltip.showText(text, bigText, this, gameObject.layer);
			else
				Tooltip.showText(text, "", this, gameObject.layer);
			lightUp();
		} catch (_:Dynamic) {}
	}
	
	public function out():Void {
		try {
			Tooltip.hideText(this);
			lightDown();
		} catch (_:Dynamic) {}
	}
	
	private function pressOut():Void
	{		
		Tooltip.showText(text, "", this, gameObject.layer);
	}
	
	private function press():Void
	{
		Tooltip.showText(text, bigText, this, gameObject.layer);
	}
	
	public function lightUp():Void {
		if (lighted) return;
		lighted = true;
		for (e in subObjects) {
			if (e.renderer.material.HasProperty('_Color')) {
				var sColor = e.renderer.material.color;
				e.renderer.material.color = new Color(sColor.r + colorMod.r, sColor.g + colorMod.g, sColor.b + colorMod.b);
			}
		}
	}
	
	public function lightDown():Void {
		if (!lighted) return;
		lighted = false;
		var i:Int = 0;
		for (e in subObjects) {
			try {
				e.renderer.material.color = savedColors[i++];
			} catch (_:Dynamic) {}
		}
	}
	
}