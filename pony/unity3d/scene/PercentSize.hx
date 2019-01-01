package pony.unity3d.scene;

import pony.IPercent;
import unityengine.MonoBehaviour;
import unityengine.Vector3;

using hugs.HUGSWrapper;

/**
 * PercentSizeUCore
 * @author AxGord <axgord@gmail.com>
 */
class PercentSize extends MonoBehaviour implements IPercent {
	
	public var percent(default, set):Float = 1;
	public var zeroInCenter:Bool = true;
	public var d:Float = 2;
	
	private var initValue:Float;
	private var initPos:Float;
	
	private function Start():Void {
		initValue = transform.lossyScale.y;
		initPos = transform.localPosition.y;
	}
	
	public function set_percent(v:Float):Float {
		if (v > 0) {
			renderer.enabled = true;
			transform.localScale = new Vector3(transform.localScale.x, v * initValue, transform.localScale.z);
			if (zeroInCenter)
				transform.localPosition = new Vector3(transform.localPosition.x, initPos - ( v < 1 ? ((1 - v) * initValue) / d : 0), transform.localPosition.z);
		} else {
			renderer.enabled = false;
		}
		return percent = v;
	}
	
}