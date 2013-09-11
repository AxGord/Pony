package pony.unity3d.scene;

import unityengine.MonoBehaviour;
import unityengine.Time;
import unityengine.Vector3;
using hugs.HUGSWrapper;

/**
 * RotorUCore
 * @author AxGord <axgord@gmail.com>
 */

class RotorUCore extends MonoBehaviour {

	public var withTimeScale:Bool = true;
	public var speed:Single = 200;
	public var direct:Vector3;
	
	public function new():Void {
		super();
		direct = new Vector3(1, 0, 0);
	}
	
	private function Update():Void {
		var sp:Single = withTimeScale ? Time.deltaTime : Time.fixedDeltaTime;
		sp *= speed;
		transform.Rotate(direct, sp);
	}
	
}