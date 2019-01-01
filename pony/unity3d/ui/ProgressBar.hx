package pony.unity3d.ui;

import pony.IPercent;
import unityengine.MonoBehaviour;
import unityengine.Rect;

using hugs.HUGSWrapper;

/**
 * ProgressBar
 * @author AxGord <axgord@gmail.com>
 */
class ProgressBar extends MonoBehaviour implements IPercent {

	public var percent(default, set):Float;
	
	private var full:Single;
	
	private function Start():Void {
		full = guiTexture.pixelInset.width;
		set(0);
	}
	
	public function set(progress:Float):Void {
		guiTexture.pixelInset = new Rect(guiTexture.pixelInset.x, guiTexture.pixelInset.y, full * progress, guiTexture.pixelInset.height);
	}
	
	inline private function set_percent(v:Float):Float {
		set(v);
		return v;
	}
	
}