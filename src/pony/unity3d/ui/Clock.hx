package pony.unity3d.ui;

import pony.time.DTimer;
import pony.time.Time;
import unityengine.GUIText;
import unityengine.MonoBehaviour;

/**
 * Clock
 * @author AxGord
 */
@:nativeGen class Clock extends MonoBehaviour {

	public var timer: DTimer;

	private static final beginTime: String = '08:00:00';

	private function Start(): Void {
		timer = DTimer.clock(beginTime);
		timer.update.add(showTimer);
		timer.dispatchUpdate();
	}

	private function showTimer(t: Time): Void guiText.text = t.clock();

}
