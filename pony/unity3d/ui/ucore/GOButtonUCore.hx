package pony.unity3d.ui.ucore;

import cs.NativeArray.NativeArray;
import pony.events.Event;
import pony.unity3d.ui.TextureButton;
import pony.ui.ButtonCore;
import unityengine.GameObject;

/**
 * GOButton
 * @author AxGord <axgord@gmail.com>
 */
class GOButtonUCore extends TextureButton {

	private var goDefs:NativeArray<GameObject>;
	private var goOvers:NativeArray<GameObject>;
	private var goPress:NativeArray<GameObject>;
	
	private var glast:GameObject;
	
	override function Start():Void {
		
		core.changeVisual.add(goRestore);
		
		for (i in 0...goOvers.Length) if (goOvers[i] != null) {
			goOvers[i].active = false;
			core.changeVisual.sub(Focus, i).add(goset.bind(goOvers[i]));
			core.changeVisual.sub(Leave, i).add(goset.bind(goOvers[i]));
		}
		
		for (i in 0...goPress.Length) if (goPress[i] != null) {
			goPress[i].active = false;
			core.changeVisual.sub(Press, i).add(goset.bind(goPress[i]));
		}
		
		for (i in 0...goDefs.Length) if (goDefs[i] != null) {
			goDefs[i].active = false;
			core.changeVisual.sub(Default, i).add(goset.bind(goDefs[i]));
		}
		
		super.Start();
	}
	
	private function goset(g:GameObject, e:Event):Void {
		restoreColor();
		guiTexture.enabled = false;
		g.active = true;
		glast = g;
		e.stopPropagation();
	}
	
	private function goRestore():Void {
		guiTexture.enabled = true;
		if (glast != null) glast.active = false;
	}
	
}