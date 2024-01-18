package pony.time;

/**
 * MainLoop
 * @author AxGord <axgord@gmail.com>
 */
class MainLoop {

	private static inline var SLEEP_TIME: Float = 1 / 62;

	public static var lastTick(default, null): Float;
	private static var _stop: Bool = false;

	public static inline function init(): Void {
		lastTick = getTime();
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function getTime(): Float return Sys.time();

	public static function start(): Void {
		var nt: Float;
		while (!_stop) {
			nt = getTime();
			var sleepTime: Float = SLEEP_TIME - (nt - lastTick);
			if (sleepTime > 0) Sys.sleep(sleepTime);
			nt = getTime();
			DeltaTime.fixedValue = nt - lastTick;
			lastTick = nt;
			DeltaTime.fixedDispatch();
		}
	}

	public static inline function stop(): Void _stop = true;

}