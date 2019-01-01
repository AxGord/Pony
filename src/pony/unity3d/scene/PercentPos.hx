package pony.unity3d.scene;

import pony.IPercent;
import unityengine.MonoBehaviour;
import unityengine.Vector3;

using hugs.HUGSWrapper;

/**
 * PercentPos
 * @author AxGord <axgord@gmail.com>
 */
class PercentPos extends MonoBehaviour implements IPercent {

	@:meta(UnityEngine.HideInInspector)
	public var percent(default, set):Float = 1;
	
	public var nullPos:Float;
	
	@:meta(UnityEngine.HideInInspector)
	private var initPos:Float;
	@:meta(UnityEngine.HideInInspector)
	private var size:Float;
	
	private function Start():Void {
		initPos = transform.localPosition.y;
		size = Math.abs(nullPos > initPos ? nullPos - initPos : initPos - nullPos);
	}
	
	public function set_percent(v:Float):Float {
		if (v > 1) v = 1;
		if (v < 0) v = 0;
		
		if (size == 0) {
			if (renderer != null) renderer.enabled = false;
			return v;
		}
		//if (v > 0 || renderer == null) {
			transform.localPosition = new Vector3(transform.localPosition.x, nullPos + size * v, transform.localPosition.z);
			if (renderer != null) renderer.enabled = true;
		//} else {
		//	renderer.enabled = false;
		//}
		return percent = v;
	}
}