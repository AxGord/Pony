package pony.js;

import js.Browser;
import pony.magic.HasSignal;
import pony.magic.Declarator;
import pony.events.Signal0;
import pony.time.DeltaTime;
import pony.time.DTimer;
import pony.time.Time;

/**
 * Window
 * @author AxGord <axgord@gmail.com>
 */
class Window implements Declarator implements HasSignal {

	private static var DEFAULT_RESIZE_INTERVAL: Time = 200;
	private static var DEFAULT_RESIZE_EVENT: String = 'resize';
	private static var ORIENTATION_CHANGE_EVENT: String = 'orientationchange';
	private static var FS_CHANGE_EVENT: String = 'fullscreenchange';
	private static var FS_CHANGE_EVENT_WEBKIT: String = 'webkitfullscreenchange';
	private static var FS_CHANGE_EVENT_MS: String = 'msfullscreenchange';
	private static var FS_CHANGE_EVENT_MOZ: String = 'mozfullscreenchange';
	private static var FOCUS_EVENT: String = 'focus';

	@:auto public static var onResize: Signal0;
	@:auto public static var onMomentalResize: Signal0;

	public static var resizeEventName(default, set): String = DEFAULT_RESIZE_EVENT;
	public static var resizeInterval(get, set): Time;
	private static var resizeTimer: DTimer = DTimer.createFixedTimer(DEFAULT_RESIZE_INTERVAL);

	private static function __init__(): Void {
		eResize.onTake << listenMomentalResize;
		eResize.onLost << unlistenMomentalResize;
		eMomentalResize.onTake << listenBrowserResize;
		eMomentalResize.onLost << unlistenBrowserResize;
		resizeTimer.complete << eResize;
	}

	private static function set_resizeEventName(name: String): String {
		if (name == null)
			name = DEFAULT_RESIZE_EVENT;
		if (name != resizeEventName) {
			if (!eMomentalResize.empty) {
				unlistenResizeEvent();
				resizeEventName = name;
				listenResizeEvent();
				eMomentalResize.dispatch();
			} else {
				resizeEventName = name;
			}
		}
		return name;
	}

	@:extern private static inline function get_resizeInterval(): Time return resizeTimer.time.max;

	private static function set_resizeInterval(value: Time): Time {
		if (value == null)
			value = DEFAULT_RESIZE_INTERVAL;
		if (value != resizeTimer.time) {
			resizeTimer.time = value;
			resizeTimer.reset();
		}
		return value;
	}

	private static function listenBrowserResize(): Void {
		Browser.window.addEventListener(ORIENTATION_CHANGE_EVENT, browserResizeHandler, true);
		Browser.window.addEventListener(FOCUS_EVENT, browserResizeHandler, true);
		Browser.window.addEventListener(FS_CHANGE_EVENT, fsChangeHandler, true);
		Browser.window.addEventListener(FS_CHANGE_EVENT_MOZ, fsChangeHandler, true);
		Browser.window.addEventListener(FS_CHANGE_EVENT_MS, fsChangeHandler, true);
		Browser.window.addEventListener(FS_CHANGE_EVENT_WEBKIT, fsChangeHandler, true);
		listenResizeEvent();
	}

	private static function unlistenBrowserResize(): Void {
		Browser.window.removeEventListener(ORIENTATION_CHANGE_EVENT, browserResizeHandler, true);
		Browser.window.removeEventListener(FOCUS_EVENT, browserResizeHandler, true);
		Browser.window.removeEventListener(FS_CHANGE_EVENT, fsChangeHandler, true);
		Browser.window.removeEventListener(FS_CHANGE_EVENT_MOZ, fsChangeHandler, true);
		Browser.window.removeEventListener(FS_CHANGE_EVENT_MS, fsChangeHandler, true);
		Browser.window.removeEventListener(FS_CHANGE_EVENT_WEBKIT, fsChangeHandler, true);
		unlistenResizeEvent();
	}

	private static function fsChangeHandler(): Void {
		browserResizeHandler();
		DeltaTime.fixedUpdate < browserResizeHandler;
		DeltaTime.skipUpdate(browserResizeHandler);
	}

	@:extern private static inline function listenResizeEvent(): Void {
		Browser.window.addEventListener(resizeEventName, browserResizeHandler, false);
	}

	@:extern private static inline function unlistenResizeEvent(): Void {
		Browser.window.removeEventListener(resizeEventName, browserResizeHandler, false);
	}

	private static function browserResizeHandler(): Void eMomentalResize.dispatch();
	private static function listenMomentalResize(): Void onMomentalResize << momentalResizeHandler;
	private static function unlistenMomentalResize(): Void onMomentalResize >> momentalResizeHandler;

	private static function momentalResizeHandler(): Void {
		resizeTimer.reset();
		resizeTimer.start();
	}

}