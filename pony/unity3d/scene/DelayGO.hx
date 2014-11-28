package pony.unity3d.scene;
import pony.time.DTimer;

/**
 * DelayGO
 * @author AxGord
 */
@:nativeGen class DelayGO extends unityengine.MonoBehaviour {

	public var go:unityengine.GameObject;
	public var delay:Float;
	@:meta(UnityEngine.HideInInspector)
	private var timer:DTimer;
	
	public function OnEnable():Void timer = DTimer.delay(delay*1000, run);
	private function run():Void go.active = true;
	public function OnDisable():Void {
		timer.destroy();
		try {
		 go.active = false;
		} catch (_:Dynamic) {}
	}
	
}