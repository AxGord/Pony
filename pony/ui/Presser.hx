package pony.ui;

import pony.time.*;

/**
 * Presser
 * @author AxGord <axgord@gmail.com>
 */
class Presser {
	
	static public var useDeltaTime = true;
	static public var pressFirstDelay:Time = 500;
	static public var pressDelay:Time = 200;
	
	private var firstTimer:ITimer<Dynamic>;
	private var secondTimer:ITimer<Dynamic>;
	
	private var callBack:Void->Void;
	
	public function new(callBack:Void->Void) {
		this.callBack = callBack;
		if (useDeltaTime) {
			firstTimer = DTimer.delay(pressFirstDelay, firstTickDelta);
		} else {
			firstTimer = Timer.delay(pressFirstDelay, firstTickClassic);
		}
	}
	
	private function firstTickDelta():Void {
		firstTimer = null;
		secondTimer = DTimer.repeat(pressDelay, callBack);
		callBack();
	}
	
	private function firstTickClassic():Void {
		firstTimer = null;
		secondTimer = Timer.repeat(pressDelay, callBack);
		callBack();
	}
	
	public function destroy():Void {
		if (firstTimer != null) {
			firstTimer.destroy();
			firstTimer = null;
		}
		if (secondTimer != null) {
			secondTimer.destroy();
			secondTimer = null;
		}
		callBack = null;
	}
	
}