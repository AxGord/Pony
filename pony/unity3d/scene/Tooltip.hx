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
package pony.unity3d.scene;

import pony.time.DeltaTime;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;
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

@:nativeGen class Tooltip extends MonoBehaviour {

	private static var colorVariants = ['_Color', '_MainTint'];
	
	public var text:String = 'tooltip';
	public var bigText:String = '';
	public var colorMod:Color;
	public var texture:Texture;
	private var savedColors:Array<Color>;
	private var savedColorsNames:Array<String>;
	
	
	@:meta(UnityEngine.HideInInspector)
	private var subs:Bool;
	private var subObjects:Array<Transform>;
	@:meta(UnityEngine.HideInInspector)
	private var ovr:MouseHelper;
	@:meta(UnityEngine.HideInInspector)
	private var lighted:Bool = false;
	
	private function Start():Void {
		if (colorMod == null || (colorMod.r == 0 && colorMod.g == 0 && colorMod.b == 0)) {
			if (pony.unity3d.Tooltip.defaultColorMod.value != null)
				colorMod = pony.unity3d.Tooltip.defaultColorMod.value;
			else
				pony.unity3d.Tooltip.defaultColorMod.add(onDCL);
		} else
			pony.unity3d.Tooltip.defaultColorMod.value = colorMod;
		if (pony.unity3d.Tooltip.texture == null) pony.unity3d.Tooltip.texture = texture;
		
		var it:NativeArrayIterator<Transform> = cast gameObject.getComponentsInChildrenOfType(Transform);
		subObjects = [for (e in it) if (e != transform && e.renderer != null) e];
		subs = subObjects.length > 0;
		if (!subs) {
			subObjects = [transform];
		}
		
		TouchManager.addListener(this.transform, over, [TouchEventType.Hover, TouchEventType.Over, TouchEventType.Down]);
		TouchManager.addListener(this.transform, out, [TouchEventType.HoverOut, TouchEventType.Out]);
		
		saveColors();
	}
	
	public function saveColors():Void {
		savedColors = [];
		savedColorsNames = [];
		for (e in subObjects) {
			for (cname in colorVariants) if (e.renderer.material.HasProperty(cname)) {
				savedColors.push(e.renderer.material.GetColor(cname));
				savedColorsNames.push(cname);
				break;
			}
		}
	}
	
	private function onDCL(cl:Color):Void {
		colorMod = cl;
	}
	
	private function over(e:TouchManagerEvent):Void {
		try {
			if (unityengine.Input.GetMouseButton(2))
					pony.unity3d.Tooltip.showText(text, bigText, this, gameObject.layer);
				else
					pony.unity3d.Tooltip.showText(text, "", this, gameObject.layer);
			lightUp();
		} catch (_:Dynamic) {}
	}
	
	public function out(_):Void {
		try {
			pony.unity3d.Tooltip.hideText(this);
			lightDown();
		} catch (_:Dynamic) {}
	}
	
	private function pressOut():Void
	{		
		pony.unity3d.Tooltip.showText(text, "", this, gameObject.layer);
	}
	
	private function press():Void
	{
		pony.unity3d.Tooltip.showText(text, bigText, this, gameObject.layer);
	}
	
	public function lightUp():Void {
		if (lighted) return;
		lighted = true;
		for (e in subObjects) {
			for (cname in colorVariants) if (e.renderer.material.HasProperty(cname)) {
				var sColor = e.renderer.material.GetColor(cname);
				e.renderer.material.SetColor(cname, new Color(sColor.r + colorMod.r, sColor.g + colorMod.g, sColor.b + colorMod.b));
				break;
			}
		}
	}
	
	public function lightDown():Void {
		if (!lighted) return;
		lighted = false;
		var i:Int = 0;
		for (e in subObjects) {
			try {
				e.renderer.material.SetColor(savedColorsNames[i], savedColors[i]);
				i++;
			} catch (_:Dynamic) {}
		}
	}
	
	
}