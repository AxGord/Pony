package pony.unity3d.scene;

import pony.time.DTimer;

/**
 * Delay
 * @author AxGord
 */
@:nativeGen class Delay extends unityengine.MonoBehaviour {

	public var script:unityengine.Behaviour;
	public var delay:Float;
	@:meta(UnityEngine.HideInInspector)
	private var timer:DTimer;
	
	public function OnEnable():Void timer = DTimer.delay(delay*1000, run);
	private function run():Void script.enabled = true;
	public function OnDisable():Void {
		timer.destroy();
		script.enabled = false;
	}
	
}