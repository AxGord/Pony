package pony.ui.touch.starling.touchManager;

import haxe.ds.ObjectMap;
import pony.ui.touch.starling.touchManager.hitTestSources.IHitTestSource;
import pony.ui.touch.starling.touchManager.TouchEventType;
#if flash
import flash.Lib;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import pony.ui.touch.starling.touchManager.hitTestSources.NativeHitTestSource;
import pony.ui.touch.starling.touchManager.touchInputs.NativeFlashTouchInput;
#end

/**
 * ...
 * @author Maletin
 */
class TouchManager {

	public static inline final MOUSE_ID: Int = 0;

	public static var GLOBAL(default, never): Dynamic = { object: 'Global' };

	private static final _objects: ObjectMap<Dynamic, Array<TouchListener>> = new ObjectMap<Dynamic, Array<TouchListener>>();
	private static final _mouse: Touch = new Touch();
	private static final _touches: Map<Int, Touch> = [];
	private static final _gestureTouches: Map<Int, Touch> = [];
	private static final _screens: Array<IHitTestSource> = [];

	private static var _gesture: Bool = false;
	private static var _initialized: Bool = false;
	private static var _lastDownEvent: TouchManagerEvent = null;

	public static inline function removeScreen(hitTest: IHitTestSource): Void {
		_screens.remove(hitTest);
	}

	public static inline function mouseWheel(d: Float): Void {
		dispatch(_mouse.current, MouseWheel, true, _mouse, d);
	}

	public static inline function getLastDownEvent(): TouchManagerEvent {
		return _lastDownEvent;
	}

	public static function init(): Void {
		if (_initialized) return;
		_initialized = true;

		#if flash
		if (Multitouch.supportsTouchEvents) Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

		InputMode.init();

		TouchManager.addScreen(new NativeHitTestSource(Lib.current.stage));

		new NativeFlashTouchInput(Lib.current.stage);
		#end
	}

	// Screens:

	public static function addScreen(hitTest: IHitTestSource, pos: Int = -1): Void {
		if (pos < 0 || pos >= _screens.length) {
			_screens.push(hitTest);
		} else {
			_screens.insert(pos, hitTest);
		}
	}

	public static function removeScreenByID(screenId: Int): Void {
		if (_screens.length > screenId && screenId >= 0) _screens.splice(screenId, 1);
	}

	// Listeners:

	public static function addListener(displayObject: Dynamic, listener: TouchManagerEvent -> Void, ?types: Array<TouchEventType>): Void {
		if (!_initialized) init();

		final exists = _objects.exists(displayObject);

		if (exists) {
			final listenersArray = _objects.get(displayObject);
			for (i in 0...listenersArray.length) {
				if (listenersArray[i].listener == listener) return;
			}
		}

		if (!exists) _objects.set(displayObject, new Array<TouchListener>());

		_objects.get(displayObject).push(new TouchListener(listener, types));
	}

	public static function removeListener(displayObject: Dynamic, listener: TouchManagerEvent -> Void): Void {
		if (!_objects.exists(displayObject)) return;

		final listenersArray = _objects.get(displayObject);

		for (i in 0...listenersArray.length) {
			if (listenersArray[i].listener == listener) {
				listenersArray.remove(listenersArray[i]);
				break;
			}
		}

		if (listenersArray.length == 0) _objects.remove(displayObject);
	}

	// Events:

	public static function move(x: Float, y: Float, touchInputMode: Bool, id: Int = MOUSE_ID, mouseDown: Bool = false): Void {

		if (_gestureTouches.exists(id)) {
			// Gesture

			final touch: Touch = _gestureTouches[id];
			var other: Touch = null;

			for (key => value in _gestureTouches) {
				if (key != id) {
					other = value;
					break;
				}
			}
			if (other == null) return;

			touch.setPos(x, y);

			var gesture: TouchManagerGesture = new TouchManagerGesture();

			dispatch(touch.active, Gesture, true, touch, 0, calculateGesture(touch, other));

			return;
		}

		// No gestures

		if (touchInputMode && !_touches.exists(id)) return;

		final touch: Touch = touchInputMode ? _touches[id] : _mouse;

		touch.setPos(x, y);

		final newCurrentObject: Dynamic = getObject(x, y);

		final newCurrentObjectChain: Array<Dynamic> = getObjectChain(newCurrentObject);
		final currentObjectChain: Array<Dynamic> = getObjectChain(touch.current);
		final activeObjectChain: Array<Dynamic> = getObjectChain(touch.active);

		var maxLength: Int = newCurrentObjectChain.length;
		if (currentObjectChain.length > maxLength) maxLength = currentObjectChain.length;
		if (activeObjectChain.length > maxLength) maxLength = activeObjectChain.length;

		dispatch(GLOBAL, Move, true, touch);

		for (i in 0...maxLength) {

			if (!touchInputMode && touch.active == null) {
				if (!commonParent(newCurrentObjectChain, currentObjectChain, i)) {
					if (currentObjectChain.length > i) dispatch(currentObjectChain[i], mouseDown ? Out : HoverOut, false, touch);
					if (newCurrentObjectChain.length > i) dispatch(newCurrentObjectChain[i], mouseDown ? Over : Hover, true, touch);
				}
			} else {
				if (
					commonParent(currentObjectChain, activeObjectChain, i) && !commonParent(newCurrentObjectChain, activeObjectChain, i)
					&& activeObjectChain.length > i
				)
					dispatch(activeObjectChain[i], Out, false, touch);
				if (
					!commonParent(currentObjectChain, activeObjectChain, i) && commonParent(newCurrentObjectChain, activeObjectChain, i)
					&& activeObjectChain.length > i
				)
					dispatch(activeObjectChain[i], Over, false, touch);

				if (activeObjectChain.length > i)
					dispatch(activeObjectChain[i], Move, commonParent(newCurrentObjectChain, activeObjectChain, i), touch);
			}
		}

		touch.current = newCurrentObject;
	}

	public static function down(x: Float, y: Float, touchInputMode: Bool, id: Int = MOUSE_ID): Void {
		if (touchInputMode) {
			if (_mouse.current != null) dispatch(_mouse.current, HoverOut, false, _mouse);

			final touchObject: Dynamic = getObject(x, y);

			final touch: Touch = new Touch();
			touch.id = id;
			touch.active = touchObject;
			touch.current = touchObject;
			touch.currentX = touch.previousX = x;
			touch.currentY = touch.previousY = y;

			// Gesture detection
			final firstKey: Int = firstKey(_touches, touchObject);
			if (firstKey != -1) {
				// trace("Gesture");
				final otherTouch: Touch = _touches[firstKey];

				if (_gesture) return; // TODO 3 points gestures?

				_gesture = true;
				_gestureTouches[firstKey] = otherTouch;
				_gestureTouches[id] = touch;

				dispatch(otherTouch.active, Up, true, otherTouch);

				_touches.remove(firstKey);

				dispatch(touch.active, GestureBegin, true, touch, 0, calculateGesture(touch, otherTouch));

				return;
			}

			_touches[id] = touch;

			dispatch(GLOBAL, Down, true, touch);
			final touchObjectChain: Array<Dynamic> = getObjectChain(touchObject);
			for (i in 0...touchObjectChain.length) {
				dispatch(touchObjectChain[i], Down, true, touch);
			}
		} else {
			_mouse.active = getObject(x, y);

			_mouse.setPos(x, y);

			final mouseActiveObjectChain: Array<Dynamic> = getObjectChain(_mouse.active);
			final mouseCurrentObjectChain: Array<Dynamic> = getObjectChain(_mouse.current);
			// for (i in 0...mouseCurrentObjectChain.length)
			// {
			// 	if (commonParent(mouseActiveObjectChain, mouseCurrentObjectChain, i)) dispatch(mouseCurrentObjectChain[i], HoverOut, false, _mouse);
			// }
			_mouse.current = _mouse.active;

			dispatch(GLOBAL, Down, true, _mouse);
			for (i in 0...mouseActiveObjectChain.length) {
				dispatch(mouseActiveObjectChain[i], Down, true, _mouse);
			}
		}
	}

	public static function up(x: Float, y: Float, touchInputMode: Bool, id: Int = MOUSE_ID): Void {
		if (_gestureTouches.exists(id)) {
			_gesture = false;

			final touch: Touch = _gestureTouches[id];

			dispatch(touch.active, GestureEnd, true, touch, 0);

			for (key in _gestureTouches.keys()) {
				if (key != id) _touches[key] = _gestureTouches[key];
				_gestureTouches.remove(key);

			}

			// trace("Gesture ended");

			return;
		}

		if (touchInputMode && !_touches.exists(id)) return;

		final touch: Touch = touchInputMode ? _touches[id] : _mouse;

		touch.setPos(x, y);

		final activeChain: Array<Dynamic> = getObjectChain(touch.active);
		final currentChain: Array<Dynamic> = getObjectChain(touch.current);

		dispatch(GLOBAL, Up, true, touch);

		for (i in 0...activeChain.length) {
			dispatch(activeChain[i], Up, commonParent(activeChain, currentChain, i), touch);
		}

		if (touchInputMode) {
			_touches.remove(id);
		} else {
			_mouse.active = null;
		}
	}

	// Dispatching:

	private static function dispatch(
		object: Dynamic, type: TouchEventType, mouseOver: Bool, touch: Touch, value: Float = 0, ?gesture: TouchManagerGesture
	): Void {
		if (object == null || !_objects.exists(object)) return;
		// trace("object = " + object + ", name = " + object.name + ", dispatching type = " + type + ", mouseOver = " + mouseOver);

		final event = new TouchManagerEvent();
		event.type = type;
		event.mouseOver = mouseOver;
		event.globalX = touch.currentX;
		event.globalY = touch.currentY;
		event.previousGlobalX = touch.previousX;
		event.previousGlobalY = touch.previousY;
		event.value = value;
		event.gesture = gesture;
		event.speedX = touch.speedX;
		event.speedY = touch.speedY;
		event.touchID = touch.id;
		event.target = object;

		if (event.type == Down) {
			_lastDownEvent = event;
		}

		final listeners = _objects.get(object);

		final copy = listeners.copy();
		for (i in 0...copy.length) if (listeners.indexOf(copy[i]) != -1 && ((copy[i].types == null) || (copy[i].types.indexOf(type) != -1)))
			copy[i].listener(event);
	}

	private static function commonParent(chainA: Array<Dynamic>, chainB: Array<Dynamic>, depth: Int): Bool {
		return chainA.length > depth && chainB.length > depth && chainA[depth] == chainB[depth];
	}

	private static function calculateGesture(touch: Touch, other: Touch): TouchManagerGesture {
		final gesture: TouchManagerGesture = new TouchManagerGesture();

		final previousScale: Float = hyp(touch.previousX - other.currentX, touch.previousY - other.currentY);
		final newScale: Float = hyp(touch.currentX - other.currentX, touch.currentY - other.currentY);

		gesture.scale = newScale / previousScale;

		gesture.movementX = (touch.currentX - touch.previousX) / 2;
		gesture.movementY = (touch.currentY - touch.previousY) / 2;

		gesture.centerX = (touch.currentX + other.currentX) / 2;
		gesture.centerY = (touch.currentY + other.currentY) / 2;

		final currentAngle: Float = Math.atan2(touch.previousX - other.currentX, touch.previousY - other.currentY);
		final previousAngle: Float = Math.atan2(touch.currentX - other.currentX, touch.currentY - other.currentY);
		gesture.angle = currentAngle - previousAngle;

		return gesture;
	}

	private static function hyp(x: Float, y: Float): Float {
		return Math.sqrt(x * x + y * y);
	}

	private static function getObject(x: Float, y: Float): Dynamic {
		var object: Dynamic;

		var i: Int = _screens.length - 1;

		while (i >= 0) {
			object = getObjectOrContainer(_screens[i], x, y);

			if (object != null) return object;

			i--;
		}

		return null;
	}

	private static function getObjectChain(object: Dynamic): Array<Dynamic> {
		final result: Array<Dynamic> = [];
		result.insert(0, object);

		var i: Int = _screens.length - 1;

		while (i >= 0) {
			var parent: Dynamic = _screens[i].parent(object);

			if (parent != null) {
				while (parent != null) {
					result.insert(0, parent);
					parent = _screens[i].parent(parent);
				}
				return result;
			}

			i--;
		}

		return result;
	}

	private static function getObjectOrContainer(screen: IHitTestSource, x: Float, y: Float): Dynamic {
		var object: Dynamic = screen.hitTest(x, y);

		if (object == null) return null;

		if (_objects.exists(object)) return object;

		while (object != null) {
			object = screen.parent(object);
			if (object != null && _objects.exists(object)) return object;
		}

		return null;
	}

	private static function firstKey(map: Map<Int, Touch>, object: Dynamic): Int {
		for (key => value in map) {
			if (value.active == object) return key;
		}

		return -1;
	}

}

private class Touch {

	private static inline final SPEED_LIST_MAX_SIZE: Int = 5;

	public var speedX: Float = 0;
	public var speedY: Float = 0;
	public var active: Dynamic;
	public var current: Dynamic;
	public var id: Int;
	public var currentX: Float;
	public var currentY: Float;
	public var previousX: Float;
	public var previousY: Float;

	private final speedListX: Array<Float> = [];
	private final speedListY: Array<Float> = [];
	private final speedListTime: Array<Float> = [];

	public function new() {}

	public function setPos(x: Float, y: Float): Void {
		previousX = currentX;
		previousY = currentY;

		currentX = x;
		currentY = y;

		speedListX.push(x);
		speedListY.push(y);
		speedListTime.push(Date.now().getTime());

		var listsLength: Int = speedListTime.length;

		if (listsLength > SPEED_LIST_MAX_SIZE) {
			speedListX.shift();
			speedListY.shift();
			speedListTime.shift();
			listsLength--;
		}

		final dt: Float = speedListTime[listsLength - 1] - speedListTime[0];

		speedX = dt == 0 ? 0 : (speedListX[listsLength - 1] - speedListX[0]) / dt;
		speedY = dt == 0 ? 0 : (speedListY[listsLength - 1] - speedListY[0]) / dt;
	}

}

private class TouchListener {

	public var listener: TouchManagerEvent -> Void;
	public var types: Array<TouchEventType>;

	public function new(listener: TouchManagerEvent -> Void, types: Array<TouchEventType>) {
		this.listener = listener;
		this.types = types;
	}

}
