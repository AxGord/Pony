package pony.time;

/**
 * MainLoop
 * @author AxGord
 */
class MainLoop {

	public static var lastTick(default, null):Float;
	private static var _stop:Bool = false;

	public static inline function init():Void {
		lastTick = getTime();
	}

	@:extern public static inline function getTime():Float return Sys.time();

	public static function start():Void {
		var nt:Float;
		while (!_stop) {
			nt = getTime();
			var sleepTime:Float = 1 / 62 - (nt - lastTick);
			if (sleepTime > 0) Sys.sleep(sleepTime);
			nt = getTime();
			DeltaTime.fixedValue = nt - lastTick;
			lastTick = nt;
			DeltaTime.fixedDispatch();
		}
	}

	public static inline function stop():Void _stop = true;

}