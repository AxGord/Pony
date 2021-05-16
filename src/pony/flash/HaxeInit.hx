package pony.flash;

import flash.events.Event;
import flash.display.MovieClip;
import flash.display.DisplayObject;
import flash.Lib;

/**
 * HaxeInit
 * @author AxGord <axgord@gmail.com>
 */
@:keep class HaxeInit {

	/**
	 * Init process started
	 */
	private static var initProcess: Bool = false;

	private static var readyListeners: Array<Void -> Void> = [];

	/**
	 * Init haxe
	 * @param st - root display object
	 */
	public static function init(st: DisplayObject, ?ready: Void -> Void): Void {
		if (readyListeners == null) {
			if (ready != null) ready();
			return;
		}
		if (ready != null) readyListeners.push(ready);
		if (initProcess) return;
		initProcess = true;
		initMath();
		inline function callReady(): Void {
			for (r in readyListeners) r();
			readyListeners = null;
		}
		#if (haxe_ver >= 4.10)
		if (Std.isOfType(st.root, MovieClip)) {
		#else
		if (Std.is(st.root, MovieClip)) {
		#end
			Lib.current = cast st;
			callReady();
		} else {
			if (ready == null) throw 'Root is not MovieClip, please change it or set ready callback';
			Lib.current = new MovieClip();
			function addedHandler(event: Event): Void {
				Lib.current.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
				callReady();
			}
			Lib.current.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			if (st.stage != null) {
				st.stage.addChild(Lib.current);
			} else {
				function stAddedHandler(event: Event): Void {
					st.removeEventListener(Event.ADDED_TO_STAGE, stAddedHandler);
					st.stage.addChild(Lib.current);
				}
				st.addEventListener(Event.ADDED_TO_STAGE, stAddedHandler);
			}
		}
	}

	private static inline function initMath(): Void {
		untyped {
			Math.NaN = __global__["Number"].NaN;
			Math.NEGATIVE_INFINITY = __global__["Number"].NEGATIVE_INFINITY;
			Math.POSITIVE_INFINITY = __global__["Number"].POSITIVE_INFINITY;
			Math.isFinite = function(i) {
				return __global__["isFinite"](i);
			};
			Math.isNaN = function(i) {
				return __global__["isNaN"](i);
			};
		}
	}

}