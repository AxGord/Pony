package pony.ui.touch.starling.touchManager;

import flash.events.Event;
import flash.Lib;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import pony.ui.touch.starling.touchManager.TouchEventType;

/**
 * TouchManagerHandCursor
 * @author Maletin
 */
class TouchManagerHandCursor {

	private static var _hand: Bool = false;
	private static var _currentHand: Bool = false;
	private static var _initialized: Bool = false;

	public var enabled(default, set): Bool = true;

	private final _object: Dynamic;

	private var _hoveringOver: Bool = false;

	public function new(object: Dynamic) {
		if (!_initialized) init();

		_object = object;

		TouchManager.addListener(_object, onTouch);
	}

	public function set_enabled(value: Bool): Bool {
		enabled = value;
		if (_hoveringOver) _hand = enabled;
		return enabled;
	}

	public function dispose(): Void {
		TouchManager.removeListener(_object, onTouch);
	}

	private function onTouch(e: TouchManagerEvent): Void {
		if (e.type == Hover) setHandCursor(Mouse.cursor == MouseCursor.BUTTON);
		setHandCursor(e.type != HoverOut && (e.type != Up || e.mouseOver));
	}

	private function setHandCursor(hand: Bool): Void {
		if (enabled) _hand = hand;
		_hoveringOver = hand;
	}

	private static function init(): Void {
		_initialized = true;

		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private static function onEnterFrame(e: Event): Void {
		if (_hand == _currentHand) return;
		_currentHand = _hand;
		Mouse.cursor = _hand ? MouseCursor.BUTTON : MouseCursor.AUTO;
	}

}
