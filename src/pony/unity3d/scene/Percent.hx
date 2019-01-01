package pony.unity3d.scene;

import pony.time.DeltaTime;
import unityengine.MonoBehaviour;
import unityengine.Vector3;

using hugs.HUGSWrapper;

/**
 * ProcentUCore
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class Percent extends MonoBehaviour {

	public var percent:Float = 1;
	public var vector:Vector3;
	
	public function new() {
		super();
		vector = new Vector3(1, 0, 0);
	}
	
	private function Start():Void {
		DeltaTime.update.add(if (vector.x != 0) updateX else if (vector.y != 0) updateY else updateZ);
		vector = new Vector3(transform.localScale.x, transform.localScale.y, transform.localScale.z);
	}
	
	private function updateX():Void transform.localScale = new Vector3(vector.x * percent, vector.y, vector.z);
	private function updateY():Void transform.localScale = new Vector3(vector.x, vector.y * percent, vector.z);
	private function updateZ():Void transform.localScale = new Vector3(vector.x, vector.y, vector.z * percent);
	
}