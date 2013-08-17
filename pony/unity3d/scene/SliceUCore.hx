package pony.unity3d.scene;
import pony.ui.ButtonCore;
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
class SliceUCore extends MonoBehaviour
{

	//public var transparentTexture:Material;
	public var untransparentTexture:Material;
	public var buttonForSlice:GameObject;
	
	private var buttonSlice:ButtonCore;
	
	private var childrenMaterials:Array<Material>;
	
	public function Start() 
	{
		childrenMaterials = [for (e in getComponentsInChildrenOfType(Renderer)) e.material];
		buttonSlice = buttonForSlice.getTypedComponent(TintButton).core;
		buttonSlice.click.add(click);
		buttonSlice.mode = 2;
	}
	
	inline private function click(mode:Int):Void 
	{
		if ( buttonSlice.mode == 2)
			for (e in getComponentsInChildrenOfType(Renderer)) e.material = untransparentTexture;
		else {
			var i:Int = 0;
			for (e in getComponentsInChildrenOfType(Renderer)) e.material = childrenMaterials[i++];
		}
	}
	
}