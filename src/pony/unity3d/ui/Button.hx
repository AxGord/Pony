package pony.unity3d.ui;

import cs.NativeArray.NativeArray;
import pony.time.DeltaTime;
import pony.ui.gui.ButtonCore;
import pony.unity3d.Tooltip;
import unityengine.Input;
import unityengine.MonoBehaviour;
import unityengine.Screen;
import unityengine.Vector3;
import pony.unity3d.Fixed2dCamera;

using hugs.HUGSWrapper;

/**
 * Simple Button
 * @see pony.ui.ButtonCore
 * @author AxGord
 */
@:nativeGen class Button extends MonoBehaviour {
	
	public var defaultMode:Int = 0;
	public var panel:Bool = true;
	public var tooltip:String = '';
	private var autoSwith:NativeArray<Int>;
	
	public var core:ButtonCore;
	
	@:meta(UnityEngine.HideInInspector)
	private var prevState:Bool = false;
	
	public function new() {
		super();
		core = new ButtonCore();
	}
	
	private function Start():Void {
		core.sw = [for (v in new NativeArrayIterator(autoSwith)) v];
		if (tooltip != '') {
			core.change.sub(ButtonStates.Focus).add(over);
			core.change.sub(ButtonStates.Default).add(out);
			core.change.sub(ButtonStates.Press).add(out);
			core.change.sub(ButtonStates.Leave).add(out);
		}
		DeltaTime.fixedUpdate < function() core.mode = defaultMode;
		
		
	}
	
	private function out():Void Tooltip.hideText(this);
	
	private function over():Void Tooltip.showText(tooltip, "", this, gameObject.layer, true);
	
	#if !touchscript
	private function Update():Void {
		var h = panel || !Fixed2dCamera.exists
			? guiTexture.HitTest(new Vector3(Input.mousePosition.x - Fixed2dCamera.begin, Input.mousePosition.y))
			: guiTexture.HitTest(new Vector3(Input.mousePosition.x +(Screen.width - Fixed2dCamera.begin)/2, Input.mousePosition.y));
		var down = Input.GetMouseButton(0);
		if (prevState != h) {
			if (h) core.mouseOver(down);
			else core.mouseOut();
			prevState = h;
		}
		if (down) core.mouseDown();
		else core.mouseUp();
	}
	#else
	private function Update():Void {
		var h = panel || !Fixed2dCamera.exists
			? guiTexture.HitTest(new Vector3(Input.mousePosition.x - Fixed2dCamera.begin, Input.mousePosition.y))
			: guiTexture.HitTest(new Vector3(Input.mousePosition.x +(Screen.width - Fixed2dCamera.begin)/2, Input.mousePosition.y));
		if (Helper.touchDown && h) {
			core.mouseOver(prevState);
			core.mouseDown();
		} else if (Helper.touchDown) {
			core.mouseOut();
			prevState = true;
		} else {
			prevState = false;
			core.mouseUp();
			core.mouseOut();
		}
	}
	#end
}