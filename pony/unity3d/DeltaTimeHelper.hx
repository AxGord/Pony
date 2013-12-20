package pony.unity3d;

import pony.DeltaTime;
import unityengine.MonoBehaviour;
import unityengine.Time;

/**
 * DeltaTimeHelper
 * @author AxGord <axgord@gmail.com>
 */
class DeltaTimeHelper extends MonoBehaviour {

	public function Update():Void {
		DeltaTime.fixedValue = Time.fixedDeltaTime;
		DeltaTime.value = DeltaTime.fixedValue * DeltaTime.speed;
		DeltaTime.update.dispatch(DeltaTime.value);
		DeltaTime.fixedUpdate.dispatch(DeltaTime.fixedValue);
	}
	
}