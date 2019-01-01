package pony.unity3d.scene;

import pony.ui.gui.ButtonCore;
import pony.unity3d.ui.TintButton;
import unityengine.Color;
import unityengine.GameObject;
import unityengine.Material;
import unityengine.MonoBehaviour;
import unityengine.Renderer;
import unityengine.Transform;

using hugs.HUGSWrapper;

/**
 * Slice
 * @author BoBaH6eToH
 */
@:nativeGen class Slice extends TooltipSaver {
	
	public var untransparentTexture:Material;
	public var buttonForSlice:GameObject;
	
	private var buttonSlice:ButtonCore;
	
	private var childrenMaterials:Array<Material>;
	
	override private function Start() 
	{
		super.Start();
		childrenMaterials = [for (e in getComponentsInChildrenOfType(Renderer)) e.material];
		buttonSlice = buttonForSlice.getTypedComponent(TintButton).core;
		buttonSlice.click.add(click);
	}
	
	inline private function click(mode:Int):Void 
	{
		if (mode == 2)
			for (e in getComponentsInChildrenOfType(Renderer)) e.material = untransparentTexture;
		else {
			var i:Int = 0;
			for (e in getComponentsInChildrenOfType(Renderer)) e.material = childrenMaterials[i++];
		}
		saveColors();
	}
	
}