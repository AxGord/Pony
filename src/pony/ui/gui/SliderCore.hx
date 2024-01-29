package pony.ui.gui;

import pony.events.Event1;
import pony.events.Signal1;
import pony.geom.Point;
import pony.ui.touch.Touch;
import pony.ui.touch.Touchable;

/**
 * SliderCore
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety class SliderCore extends BarCore {

	@:nullSafety(Off) @:bindable public var finalPercent: Float = 0;
	@:nullSafety(Off) @:bindable public var finalPos: Float = 0;
	@:nullSafety(Off) @:bindable public var finalValue: Float = 0;

	public var useTouchPos: Bool = false;
	public var onStartDrag(default, null): Signal1<Touch>;
	public var onStopDrag(default, null): Signal1<Touch>;

	private var draggable: Bool;
	private var startPoint: Float = 0;
	public var wheelSpeed: Float = 2;

	public var trackStartPoint: Null<Float> = null;
	public var track(default, set): Null<Touchable>;

	@:arg private var button: Null<ButtonCore> = null;

	public function new(size: Float, isVertical: Bool = false, invert: Bool = false, draggable: Bool = true) {
		super(size, isVertical, invert);
		this.draggable = draggable;
		if (button != null) {
			onStartDrag = button.touch.onDown;
			onStopDrag = button.touch.onUp || button.touch.onOutUp;
		} else {
			onStartDrag = new Event1();
			onStopDrag = new Event1();
		}
		onStopDrag << stopDragHandler;
		if (draggable) {
			onStartDrag << (isVertical ? startYDragHandler : startXDragHandler);
			onStartDrag << startDragHandler;
		}
		if (button != null) changePos << button.touch.check;
	}

	public dynamic function convertPos(p: Point<Float>): Point<Float> return p;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function create(
		?b: ButtonCore, width: Float, height: Float, invert: Bool = false, draggable: Bool = true
	): SliderCore {
		var isVert: Bool = height > width;
		return new SliderCore(b, isVert ? height : width, isVert, invert, draggable);
	}

	override public function destroy(): Void {
		destroySignals();
		if (button != null) button.destroy();
	}

	private function stopDragHandler(t: Touch): Void {
		if (t != null) t.onMove >> moveHandler;
		finalPos = pos;
		finalPercent = percent;
		finalValue = value;
		if (button != null) changePos << button.touch.check;
	}

	public inline function startDrag(t: Touch): Void untyped (onStartDrag: Event1<Touch>).dispatch(t);
	public inline function stopDrag(t: Touch): Void untyped (onStopDrag: Event1<Touch>).dispatch(t);

	private function startXDragHandler(t: Touch): Void {
		startPoint = useTouchPos || trackStartPoint == null ? inv(pos) - convertPos(t).x : -trackStartPoint;
	}

	private function startYDragHandler(t: Touch): Void {
		startPoint = useTouchPos || trackStartPoint == null ? inv(pos) - convertPos(t).y : -trackStartPoint;
	}

	private function startDragHandler(t: Touch): Void {
		if (t != null) t.onMove << moveHandler;
		if (button != null) changePos >> button.touch.check;
	}

	private function moveHandler(t: Touch): Void pos = limit(detectPos(t.point));

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function detectPos(p: Point<Float>): Float {
		p = convertPos(p);
		return inv((isVertical ? p.y : p.x) + startPoint);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function limit(p: Float): Float return if (p < 0) 0 else if (p > size) size else p;

	public inline function wheel(v: Float): Void scroll(wheelSpeed * v);
	public inline function scroll(v: Float): Void if (size >= 1) pos = limit(pos - v);
	public inline function wheelValue(v: Float): Void scrollValue(-wheelSpeed * v);
	public inline function scrollValue(v: Float): Void setPosValue(value - v);

	public inline function update(): Void {
		var p: Float = pos;
		pos = 0;
		pos = limit(p);
	}

	public inline function setPosValue(v: Float): Void {
		if (size >= 1) {
			value = v;
			finalValue = v;
			update();
		}
	}

	private function moveTo(t: Touch): Void moveToPoint(t.point);

	public function moveToPoint(t: Point<Float>): Void {
		if (trackStartPoint != null) startPoint = -trackStartPoint;
		pos = limit(detectPos(t));
	}

	public function set_track(v: Null<Touchable>): Null<Touchable> {
		if (track != v) {
			if (track != null) {
				track.onDown >> startDrag;
				track.onDown >> stopDrag;
			}
			track = v;
			if (v != null) {
				if (trackStartPoint != null)
					v.onDown << moveTo;
				v.onDown << startDrag;
				v.onUp << stopDrag;
				v.onOutUp << stopDrag;
			}
		}
		return v;
	}

}