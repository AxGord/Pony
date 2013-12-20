package pony.unity3d.ui.ucore;

import cs.NativeArray.NativeArray;
import pony.events.Event;
import pony.unity3d.ui.TintButton;
import unityengine.Texture;
import pony.ui.ButtonCore;

using hugs.HUGSWrapper;

/**
 * TextureButton
 * @author AxGord <axgord@gmail.com>
 */
class TextureButtonUCore extends TintButton {

	private var defs:NativeArray<Texture>;
	private var overs:NativeArray<Texture>;
	private var press:NativeArray<Texture>;
	
	override function Start():Void {
		
		for (i in 0...overs.Length) if (overs[i] != null) {
			core.changeVisual.sub(Focus, i).add(txset.bind(overs[i]));
			core.changeVisual.sub(Leave, i).add(txset.bind(overs[i]));
		}
		
		for (i in 0...press.Length) if (press[i] != null)
			core.changeVisual.sub(Press, i).add(txset.bind(press[i]));
			
		
		if (defs.Length == 0)
			core.changeVisual.sub(Default, 0).add(txset.bind(guiTexture.texture));
		else {
			defs[0] = guiTexture.texture;	
			for (i in 0...defs.Length) if (defs[i] != null) {
				core.changeVisual.sub(Default, i).add(txset.bind(defs[i]));
				core.changeVisual.sub(Focus, i).add(_txset.bind(defs[i]));
				core.changeVisual.sub(Leave, i).add(_txset.bind(defs[i]));
				core.changeVisual.sub(Press, i).add(_txset.bind(defs[i]));
			}
		}
		
		super.Start();
	}
	
	private function txset(t:Texture, e:Event):Void {
		restoreColor();
		guiTexture.texture = t;
		e.stopPropagation();
	}
	
	private function _txset(t:Texture):Void {
		guiTexture.texture = t;
	}
	
}