package pony.unity3d.scene;

import unityengine.MonoBehaviour;

using hugs.HUGSWrapper;

/**
 * TooltipSaver
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class TooltipSaver extends MonoBehaviour {

	private var tooltips:Array<Tooltip>;
	
	private function Start():Void {
		var tooltip:Tooltip = null;
		if (tooltip == null) tooltip = gameObject.getTypedComponent(Tooltip);
		if (tooltip == null) tooltip = gameObject.getParentTypedComponent(Tooltip);
		if (tooltip == null) {
			tooltips = gameObject.getComponentsInChildrenOfType(Tooltip).haxeArray();
		} else
			tooltips = [tooltip];
	}
	
	inline private function saveColors():Void {
		for (e in tooltips) e.saveColors();
	}
	
}