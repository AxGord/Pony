package pony.unity3d.scene.ucore;

import pony.IPercent;
import unityengine.MonoBehaviour;
import unityengine.Vector3;

using hugs.HUGSWrapper;

/**
 * PercentPos
 * @author AxGord <axgord@gmail.com>
 */

class PercentPosUCore extends MonoBehaviour implements IPercent {

	public var percent(default, set):Float = 1;
	
	public var nullPos:Float;
	
	private var initPos:Float;
	private var size:Float;
	
	private function Start():Void {
		initPos = transform.localPosition.y;
		size = Math.abs(nullPos > initPos ? nullPos - initPos : initPos - nullPos);
	}
	
	public function set_percent(v:Float):Float {
		if (size == 0) {
			if (renderer != null) renderer.enabled = false;
			return v;
		}
		if (v > 0 || renderer == null) {
			transform.localPosition = new Vector3(transform.localPosition.x, nullPos + size * v, transform.localPosition.z);
			if (renderer != null) renderer.enabled = true;
		} else {
			renderer.enabled = false;
		}
		return percent = v;
	}
	
}