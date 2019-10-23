package pony.time;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.magic.HasSignal;

/**
 * Delta Time
 * @author AxGord
 */
class DeltaTime implements HasSignal {
	
	@:lazy public static var update: Signal1<DT>;
	@:lazy public static var fixedUpdate: Signal1<DT>;

	public static var speed: Float = 1;
	public static var value: Float = 0;
	private static var t: Float;
	public static var nowDate(get, never): Date;

	#if (HUGS && !WITHOUTUNITY)
	public static var fixedValue(get, never): Float;
	private static inline function get_fixedValue(): Float return unityengine.Time.deltaTime;
	#else
	public static var fixedValue: Float = 0;
	#end
	
	#if !((flash || openfl) || HUGS)
	public static inline function init(?signal: Signal0): Void {
		set();
		if (signal != null) signal.add(tick);
	}
	#end
	
	#if openfl
	public static function tick(): Void {
		fixedValue = get();
		set();
		fixedDispatch();
	}
	
	private static var lastNow:Date;
	
	inline private static function get_nowDate(): Date return lastNow;
	
	private inline static function set(): Void {
		t = openfl.Lib.getTimer();
		lastNow = Date.fromTime(t);
	}
	
	private inline static function get(): Float return (openfl.Lib.getTimer() - t) / 1000;
	
	#elseif !HUGS
	public static function tick(): Void {
		fixedValue = get();
		set();
		fixedDispatch();
	}
	
	private static var lastNow: Date;
	
	private static inline function get_nowDate(): Date return lastNow;
	
	private static inline function set(): Void {
		lastNow = Date.now();
		t = lastNow.getTime();
	}
	private static inline function get(): Float return (Date.now().getTime() - t) / 1000;
	
	#else
	private static inline function get_nowDate(): Date return Date.now();
	#end
	
	public static inline function fixedDispatch(): Void eFixedUpdate.dispatch(fixedValue);
	
	#if ((flash || openfl) && !munit)
	
	private static var addListenerTimer: haxe.Timer;

	private static function __init__(): Void {
		createSignals();
		eFixedUpdate.onTake.add(_ftakeListeners);
		eFixedUpdate.onLost.add(_flostListeners);
	}

	private static function _ftakeListeners(): Void {
		_set();
		addListenerTimer = pony.flash.FLTools.getStage(getStageHandler);
	}

	private static function getStageHandler(stage: flash.display.Stage): Void {
		addListenerTimer = null;
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, _tick, false, 1000, true);
	}

	private static function _flostListeners(): Void {
		if (flash.Lib.current != null) {
			flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, _tick);
		} else {
			addListenerTimer.stop();
			addListenerTimer = null;
		}
	}

	private static function _tick(_): Void tick();
	private static inline function _set(): Void set();

	#end
	
	#if (!(flash || openfl) || munit)
	private static function __init__(): Void {
		createSignals();
	}
	#end
	
	#if (nodejs && nodedt)
	private static var imm: Dynamic;
	private static function __init__(): Void {
		createSignals();
		eFixedUpdate.onTake << _ftakeListeners;
		eFixedUpdate.onLost << _flostListeners;
	}
	private static function _ftakeListeners(): Void {
		set();
		imm = js.Node.setInterval(tick, Std.int(1000 / 60)); // 60 FPS
	}
	
	private static function _flostListeners(): Void js.Node.clearInterval(imm);
	#end
	
	private static inline function createSignals(): Void {
		update; // Create update signal
		fixedUpdate; // Create fixedUpdate signal
		eUpdate.onTake.add(_takeListeners);
		eUpdate.onLost.add(_lostListeners);
	}
	
	private static function updateHandler(dt: DT): Void {
		if (speed > 0 && dt > 0) {
			value = dt * speed;
			eUpdate.dispatch(value);
		}
	}
	
	private static function _takeListeners(): Void fixedUpdate.add(updateHandler);
	private static function _lostListeners(): Void fixedUpdate.remove(updateHandler);
	
	public static function skipUpdate(f:Void -> Void): Void DeltaTime.fixedUpdate < function() DeltaTime.fixedUpdate < f;
	
	public static function skipFrames(n: Int, f:Void -> Void):Void {
		if (n == 0)
			f();
		else
			DeltaTime.fixedUpdate < skipFrames.bind(n - 1, f);
	}
	
	public static function notInstant(cb: Void -> Void): Void -> Void {
		var instant = true;
		DeltaTime.fixedUpdate < function() instant = false;
		return function() instant ? DeltaTime.fixedUpdate < cb : cb();
	}
	
	#if (munit || dox || tink_unittest)
	/**
	 * For unit tests
	 * @param	time
	 * @see pony.time.Time
	 */
	public static function testRun(time: Time = 60000): Void {
		var sec:Float = time / 1000;
		var d = if (sec < 100) 10 else if (sec < 1000) 50 else 100; // d > 100 sec - not normal lag
		while (sec > 0) {
			var r = Math.random() * d;
			if (sec >= r)
				sec -= r;
			else {
				r = sec;
				sec = 0;
			}
			fixedValue = r;
			fixedDispatch();
		}
	}
	#end
}