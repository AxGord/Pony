package pony.time;

#if js
import js.Browser;
import pony.events.Signal0;

/**
 * JsDT
 * @author AxGord <axgord@gmail.com>
 */
class JsDT implements pony.magic.HasSignal {

	@:auto public static var onRender:Signal0;

	public static var half(default, set):Bool;
	
	/**
	 * Switch half mode for mobile devices 
	 */
	public static var halfMobile(never, set):Bool;
	
	public static var inited(default, null):Bool = false;
	
	private static var afid:Int = -1;
	private static var ms:Float = 0;
	private static var allowFastTickAbort:Bool = false;
	private static var allowHalfTick:Bool = false;
	private static var blurId:Int;
	public static var rareTime:Int = 10000;
	
	private static function init():Void {
		inited = true;
		half = JsTools.isMobile;
		if (Browser.window.requestAnimationFrame != null) raf = Browser.window.requestAnimationFrame;
		else if (untyped Browser.window.mozRequestAnimationFrame != null) raf = untyped Browser.window.mozRequestAnimationFrame;
		else if (untyped Browser.window.webkitRequestAnimationFrame != null) raf = untyped Browser.window.webkitRequestAnimationFrame;
		else if (untyped Browser.window.msRequestAnimationFrame != null) raf = untyped Browser.window.msRequestAnimationFrame;
		if (Browser.window.cancelAnimationFrame != null) caf = Browser.window.cancelAnimationFrame;
		else if (untyped Browser.window.mozCancelAnimationFrame != null) caf = untyped Browser.window.mozCancelAnimationFrame;
		else if (untyped Browser.window.webkitCancelAnimationFrame != null) caf = untyped Browser.window.webkitCancelAnimationFrame;
		else if (untyped Browser.window.msCancelAnimationFrame != null) caf = untyped Browser.window.msCancelAnimationFrame;
	}
	
	private static dynamic function raf(cb:Float -> Void):Int return throw 'Not set';
	private static dynamic function caf(id:Int):Void return throw 'Not set';
	
	private static function set_half(b:Bool):Bool {
		if (!inited) {
			init();
			return half = b;
		}
		if (half != b) {
			half = b;
			if (afid != -1) {
				stop();
				start();
			}
		}
		return b;
	}
	
	@:extern private static inline function set_halfMobile(b:Bool):Bool {
		if (JsTools.isMobile) half = b;
		return half;
	}
	
	public static function start():Void {
		if (!inited) init();
		if (half) {
			allowHalfTick = true;
			afid = raf(halfTick1);
		} else {
			allowFastTickAbort = true;
			afid = raf(fastTick);
		}
	}
	
	@:extern public static inline function stop():Void {
		caf(afid);
		afid = -1;
		if (half)
			allowFastTickAbort = false;
		else
			allowHalfTick = false;
	}
	
	private static function halfTick1(v:Float):Void {
		tick(v);
		if (allowHalfTick)
			afid = raf(halfTick2);
	}
	
	private static function halfTick2(v:Float):Void {
		eRender.dispatch();
		afid = raf(halfTick1);
	}
	
	private static function fastTick(v:Float):Void {
		tick(v);
		eRender.dispatch();
		if (allowFastTickAbort)
			afid = raf(fastTick);
	}
	
	@:extern private static inline function tick(v:Float):Void {
		DeltaTime.fixedValue = (v - ms) / 1000;
		ms = v;
		DeltaTime.fixedDispatch();
	}
	
	public static function blur():Void {
		stop();
		blurId = Browser.window.setInterval(rareTick, rareTime);
	}
	
	public static function focus():Void {
		Browser.window.clearInterval(blurId);
		start();
	}
	
	private static function rareTick():Void {
		DeltaTime.fixedValue = rareTime / 1000;
		ms += rareTime;
		DeltaTime.fixedDispatch();
	}
	
}
#end