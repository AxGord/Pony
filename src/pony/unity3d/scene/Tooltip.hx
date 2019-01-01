package pony.unity3d.scene;

import pony.time.DeltaTime;
import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;
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