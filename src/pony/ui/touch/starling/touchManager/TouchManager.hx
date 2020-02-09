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

	public static var GLOBAL(default, never): Dynamic = {object: 'Global'};
	public static inline var MOUSE_ID: Int = 0;

	private static var _objects: ObjectMap<Dynamic, Array<TouchListener>> = new ObjectMap<Dynamic, Array<TouchListener>>();

	private static var _mouse: Touch = new Touch();

	private static var _touches: Map<Int, Touch> = new Map<Int, Touch>();

	private static var _gesture: Bool = false;
	private static var _gestureTouches: Map<Int, Touch> = new Map<Int, Touch>();

	private static var _screens: Array<IHitTestSource> = new Array<IHitTestSource>();
	private static var _initialized: Bool = false;

	private static var _lastDownEvent: TouchManagerEvent = null;

	public static function init(): Void {
		if (_initialized)
			return;
		_initialized = true;

		#if flash
		if (Multitouch.supportsTouchEvents)
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

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

	public static function removeScreen(hitTest: IHitTestSource): Void {
		_screens.remove(hitTest);
	}

	public static function removeScreenByID(screenId: Int): Void {
		if (_screens.length > screenId && screenId >= 0)
			_screens.splice(screenId, 1);
	}

	// Listeners:

	public static function addListener(displayObject: Dynamic, listener: TouchManagerEvent->Void, types: Array<TouchEventType> = null): Void {
		if (!_initialized)
			init();

		var exists = _objects.exists(displayObject);

		if (exists) {
			var listenersArray = _objects.get(displayObject);
			for (i in 0...listenersArray.length) {
				if (listenersArray[i].listener == listener)
					return;
			}
		}

		if (!exists)
			_objects.set(displayObject, new Array<TouchListener>());

		_objects.get(displayObject).push(new TouchListener(listener, types));
	}

	public static function removeListener(displayObject: Dynamic, listener: TouchManagerEvent->Void): Void {
		if (!_objects.exists(displayObject))
			return;

		var listenersArray = _objects.get(displayObject);

		for (i in 0...listenersArray.length) {
			if (listenersArray[i].listener == listener) {
				listenersArray.remove(listenersArray[i]);
				break;
			}
		}

		if (listenersArray.length == 0)
			_objects.remove(displayObject);
	}

	// Events:

	public static function move(x: Float, y: Float, touchInputMode: Bool, id: Int = MOUSE_ID, mouseDown: Bool = false): Void {

		if (_gestureTouches.exists(id)) {
			// Gesture

			var touch: Touch = _gestureTouches.get(id);
			var other: Touch = null;

			for (key in _gestureTouches.keys()) {
				if (key != id) {
					other = _gestureTouches.get(key);
					break;
				}
			}
			if (other == null)
				return;

			touch.setPos(x, y);

			var gesture: TouchManagerGesture = new TouchManagerGesture();

			dispatch(touch.active, Gesture, true, touch, 0, calculateGesture(touch, other));

			return;
		}

		// No gestures

		if (touchInputMode && !_touches.exists(id))
			return;

		var touch: Touch = touchInputMode ? _touches.get(id) : _mouse;

		touch.setPos(x, y);

		var newCurrentObject: Dynamic = getObject(x, y);

		var newCurrentObjectChain: Array<Dynamic> = getObjectChain(newCurrentObject);
		var currentObjectChain: Array<Dynamic> = getObjectChain(touch.current);
		var activeObjectChain: Array<Dynamic> = getObjectChain(touch.active);

		var maxLength: Int = newCurrentObjectChain.length;
		if (currentObjectChain.length > maxLength)
			maxLength = currentObjectChain.length;
		if (activeObjectChain.length > maxLength)
			maxLength = activeObjectChain.length;

		dispatch(GLOBAL, Move, true, touch);

		for (i in 0...maxLength) {

			if (!touchInputMode && touch.active == null) {
				if (!commonParent(newCurrentObjectChain, currentObjectChain, i)) {
					if (currentObjectChain.length > i)
						dispatch(currentObjectChain[i], mouseDown ? Out : HoverOut, false, touch);
					if (newCurrentObjectChain.length > i)
						dispatch(newCurrentObjectChain[i], mouseDown ? Over : Hover, true, touch);
				}
			} else {
				if (commonParent(currentObjectChain, activeObjectChain, i)
					&& !commonParent(newCurrentObjectChain, activeObjectChain, i)
					&& activeObjectChain.length > i)
					dispatch(activeObjectChain[i], Out, false, touch);
				if (!commonParent(currentObjectChain, activeObjectChain, i)
					&& commonParent(newCurrentObjectChain, activeObjectChain, i)
					&& activeObjectChain.length > i)
					dispatch(activeObjectChain[i], Over, false, touch);

				if (activeObjectChain.length > i)
					dispatch(activeObjectChain[i], Move, commonParent(newCurrentObjectChain, activeObjectChain, i), touch);
			}
		}

		touch.current = newCurrentObject;
	}

	public static function down(x: Float, y: Float, touchInputMode: Bool, id: Int = MOUSE_ID): Void {
		if (touchInputMode) {
			if (_mouse.current != null)
				dispatch(_mouse.current, HoverOut, false, _mouse);

			var touchObject: Dynamic = getObject(x, y);

			var touch: Touch = new Touch();
			touch.id = id;
			touch.active = touchObject;
			touch.current = touchObject;
			touch.currentX = touch.previousX = x;
			touch.currentY = touch.previousY = y;

			// Gesture detection
			var firstKey: Int = firstKey(_touches, touchObject);
			if (firstKey != -1) {
				// trace("Gesture");
				var otherTouch: Touch = _touches.get(firstKey);

				if (_gesture)
					return; // TODO 3 points gestures?

				_gesture = true;
				_gestureTouches.set(firstKey, otherTouch);
				_gestureTouches.set(id, touch);

				dispatch(otherTouch.active, Up, true, otherTouch);

				_touches.remove(firstKey);

				dispatch(touch.active, GestureBegin, true, touch, 0, calculateGesture(touch, otherTouch));

				return;
			}

			_touches.set(id, touch);

			dispatch(GLOBAL, Down, true, touch);
			var touchObjectChain: Array<Dynamic> = getObjectChain(touchObject);
			for (i in 0...touchObjectChain.length) {
				dispatch(touchObjectChain[i], Down, true, touch);
			}
		} else {
			_mouse.active = getObject(x, y);

			_mouse.setPos(x, y);

			var mouseActiveObjectChain: Array<Dynamic> = getObjectChain(_mouse.active);
			var mouseCurrentObjectChain: Array<Dynamic> = getObjectChain(_mouse.current);
			/*
				for (i in 0...mouseCurrentObjectChain.length)
				{
					if (commonParent(mouseActiveObjectChain, mouseCurrentObjectChain, i)) dispatch(mouseCurrentObjectChain[i], HoverOut, false, _mouse);
				}
			 */
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

			var touch: Touch = _gestureTouches.get(id);

			dispatch(touch.active, GestureEnd, true, touch, 0);

			for (key in _gestureTouches.keys()) {
				if (key != id)
					_touches.set(key, _gestureTouches.get(key));
				_gestureTouches.remove(key);

			}

			// trace("Gesture ended");

			return;
		}

		if (touchInputMode && !_touches.exists(id))
			return;

		var touch: Touch = touchInputMode ? _touches.get(id) : _mouse;

		touch.setPos(x, y);

		var activeChain: Array<Dynamic> = getObjectChain(touch.active);
		var currentChain: Array<Dynamic> = getObjectChain(touch.current);

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

	public static function mouseWheel(d: Float): Void {
		dispatch(_mouse.current, MouseWheel, true, _mouse, d);
	}

	// Dispatching:

	private static function dispatch(object: Dynamic, type: TouchEventType, mouseOver: Bool, touch: Touch, value: Float = 0,
			gesture: TouchManagerGesture = null): Void {
		if ((object != null) && (_objects.exists(object))) {
			// trace("object = " + object + ", name = " + object.name + ", dispatching type = " + type + ", mouseOver = " + mouseOver);

			var event = new TouchManagerEvent();
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

			var listeners = _objects.get(object);

			var copy = listeners.copy();
			for (i in 0...copy.length) {
				if (listeners.indexOf(copy[i]) == -1)
					continue;
				if ((copy[i].types == null) || (copy[i].types.indexOf(type) != -1))
					copy[i].listener(event);
			}
		}
	}

	public static function getLastDownEvent(): TouchManagerEvent {
		return _lastDownEvent;
	}

	private static function commonParent(chainA: Array<Dynamic>, chainB: Array<Dynamic>, depth: Int): Bool {
		if (chainA.length <= depth || chainB.length <= depth)
			return false;
		return chainA[depth] == chainB[depth];
	}

	private static function calculateGesture(touch: Touch, other: Touch): TouchManagerGesture {
		var gesture: TouchManagerGesture = new TouchManagerGesture();

		var previousScale: Float = hyp(touch.previousX - other.currentX, touch.previousY - other.currentY);
		var newScale: Float = hyp(touch.currentX - other.currentX, touch.currentY - other.currentY);

		gesture.scale = newScale / previousScale;

		gesture.movementX = (touch.currentX - touch.previousX) / 2;
		gesture.movementY = (touch.currentY - touch.previousY) / 2;

		gesture.centerX = (touch.currentX + other.currentX) / 2;
		gesture.centerY = (touch.currentY + other.currentY) / 2;

		var currentAngle: Float = Math.atan2(touch.previousX - other.currentX, touch.previousY - other.currentY);
		var previousAngle: Float = Math.atan2(touch.currentX - other.currentX, touch.currentY - other.currentY);
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

			if (object != null)
				return object;

			i--;
		}

		return null;
	}

	private static function getObjectChain(object: Dynamic): Array<Dynamic> {
		var result: Array<Dynamic> = new Array<Dynamic>();
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

		if (object == null)
			return null;

		if (_objects.exists(object))
			return object;

		while (object != null) {
			object = screen.parent(object);
			if (object != null && _objects.exists(object))
				return object;
		}

		return null;
	}

	private static function firstKey(map: Map<Int, Touch>, object: Dynamic): Int {
		for (key in map.keys()) {
			if (map.get(key).active == object)
				return key;
		}

		return -1;
	}

}

private class Touch {

	public var active: Dynamic;
	public var current: Dynamic;

	public var id: Int;

	public var currentX: Float;
	public var currentY: Float;

	public var previousX: Float;
	public var previousY: Float;

	public var speedX: Float = 0;
	public var speedY: Float = 0;

	private var speedListX: Array<Float> = new Array<Float>();
	private var speedListY: Array<Float> = new Array<Float>();
	private var speedListTime: Array<Float> = new Array<Float>();

	private static var SPEED_LIST_MAX_SIZE: Int = 5;

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

		var dt: Float = speedListTime[listsLength - 1] - speedListTime[0];

		speedX = (dt == 0) ? 0 : (speedListX[listsLength - 1] - speedListX[0]) / dt;
		speedY = (dt == 0) ? 0 : (speedListY[listsLength - 1] - speedListY[0]) / dt;
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