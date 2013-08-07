package pony.unity3d.scene;

import pony.DeltaTime;
import pony.unity3d.scene.MouseHelper;
import unityengine.BoxCollider;
import unityengine.Color;
import unityengine.MonoBehaviour;
import pony.unity3d.Tooltip;
import unityengine.Texture;
import unityengine.Transform;

using hugs.HUGSWrapper;
using pony.unity3d.UnityHelper;

/**
 * TooltipUCore
 * @author AxGord <axgord@gmail.com>
 */

class TooltipUCore extends MonoBehaviour {

	public var text:String = 'tooltip';
	public var bigText:String = '';
	public var colorMod:Color;
	public var texture:Texture;
	
	private var savedColors:Array<Color>;
	
	private var subs:Bool;
	private var subObjects:Array<Transform>;
	
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
		
		savedColors = [];
		
		var ovr:MouseHelper = getOrAddTypedComponent(MouseHelper);
		ovr.over.add(overDelay);
		ovr.out.add(out);
		ovr.down.add(function()trace('click'));
		
		for (e in subObjects)
			savedColors.push(e.renderer.material.color);
	}
	
	private function onDCL(cl:Color):Void {
		colorMod = cl;
	}
	
	private function overDelay():Void {
		DeltaTime.update.once(overDelay2);
	}
	
	private function overDelay2():Void {
		DeltaTime.update.once(over);
	}
	
	private function over():Void {
		Tooltip.showText(text, gameObject.layer);
		lightUp();
	}
	
	private function out():Void {
		Tooltip.hideText();
		lightDown();
	}
	
	public function lightUp():Void {
		for (e in subObjects) {
			var sColor = e.renderer.material.color;
			e.renderer.material.color = new Color(sColor.r + colorMod.r, sColor.g + colorMod.g, sColor.b + colorMod.b);
		}
	}
	
	public function lightDown():Void {
		var i:Int = 0;
		for (e in subObjects) {
			e.renderer.material.color = savedColors[i++];
		}
	}
	
}