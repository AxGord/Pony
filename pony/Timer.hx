package pony;

import pony.events.Signal;

/**
 * ...
 * @author AxGord
 */
class Timer extends Signal {
	
	public var delay(default, null):Int;

	private var t:haxe.Timer;
	
	public function new(delay:Int, autoStart:Bool = true) {
		super();
		this.delay = delay;
		if (autoStart) start();
	}
	
	public function start():Timer {
		stop();
		t = new haxe.Timer(delay);
		t.run = run;
		return this;
	}
	
	private function run():Void dispatch();
	
	public function stop():Timer {
		if (t != null) {
			t.stop();
			t = null;
		}
		return this;
	}
	
	public inline function clear():Void {
		stop();
		removeAllListeners();
	}
	
	public inline function setTickCount(count:Int):Timer {
		add(function() if (--count == 0) clear(), 10000);
		return this;
	}
	
	public static function tick(delay:Int):Timer {
		return new Timer(delay).setTickCount(1);
	}
	
}