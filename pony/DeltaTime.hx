package pony;
import pony.events.Signal;

/**
 * ...
 * @author AxGord
 */
class DeltaTime {

	public static var update(default,null):Signal = new Signal();
	public static var value(default,null):Float = 0;
	
	private static var t:Float;
	
	public static inline function init(?signal:Signal):Void {
		set();
		if (signal != null) signal.add(tick);
	}
	
	public static function tick():Void {
		update.dispatch(value = get());
		set();
	}
	
	private inline static function set():Void t = Date.now().getTime();
	
	private inline static function get():Float return (Date.now().getTime() - t) / 1000;
	
}