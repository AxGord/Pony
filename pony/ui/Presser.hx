package pony.ui;

import pony.time.ITimer;
import pony.time.DTimer;
import pony.time.Time;
import pony.time.DT;

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
	
	private var callBack:Void -> Void;
	
	public function new(callBack:Void -> Void) {
		this.callBack = callBack;
		if (useDeltaTime) {
			firstTimer = DTimer.fixedDelay(pressFirstDelay, firstTickDelta);
		} else {
			#if (!neko || munit)
			firstTimer = pony.time.Timer.delay(pressFirstDelay, firstTickClassic);
			#end
		}
	}
	
	private function firstTickDelta(dt:DT):Void {
		firstTimer = null;
		secondTimer = DTimer.fixedRepeat(pressDelay, callBack, dt);
		callBack();
	}
	#if (!neko || munit)
	private function firstTickClassic():Void {
		firstTimer = null;
		secondTimer = pony.time.Timer.repeat(pressDelay, callBack);
		callBack();
	}
	#end
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