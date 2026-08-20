package pony.geom.drawshape;

import pony.events.Signal1;
import pony.events.Signal2;
import pony.geom.Point;
import pony.geom.Rect;
import pony.ui.touch.Touch;
import pony.ui.touch.Touchable;

/**
 * DrawShapePointer
 * @author AxGord <axgord@gmail.com>
 */
class DrawShapePointer extends pony.Tumbler {

	private static inline final PRIORITY: Int = -10;

	public var xbegin(default, null): Float = 0;
	public var ybegin(default, null): Float = 0;
	public var snapCellCounts(default, null): Point<Int> = new Point<Int>(12, 12);
	public var snapCellSize(default, null): Point<Float>;

	@:auto public var onDrawPoint: Signal2<DrawShapePointerData, Touch>;
	@:auto public var onHidePoint: Signal1<Touch>;
	@:auto public var onDownPoint: Signal2<DrawShapePointerData, Touch>;

	private final touchable: Touchable;

	private var width: Float;
	private var height: Float;
	private var downPointData: DrawShapePointerData;
	private var lastTouch: Touch;

	public function new(touchable: Touchable, width: Float, height: Float, ?snapCellCounts: Point<Int>) {
		super(false);
		this.touchable = touchable;
		if (width > height) {
			xbegin = (width - height) / 2;
			width = height;
		} else {
			ybegin = (height - width) / 2;
			height = width;
		}
		this.width = width;
		this.height = height;
		if (snapCellCounts != null) this.snapCellCounts = snapCellCounts;
		snapCellSize = new Point(width / this.snapCellCounts.x, height / this.snapCellCounts.y);
		onDrawPoint.add(magnet, PRIORITY);
		onDrawPoint.add(drawPointHandler, PRIORITY);
		onHidePoint.add(hidePointHandler, PRIORITY);
		onEnable << enableHandler;
		onDisable << disableHandler;
	}

	public inline function hidePoint(t: Touch): Void eHidePoint.dispatch(t);

	public function drawSnap(): Array<Pair<Bool, Rect<Float>>> {
		final r: Array<Pair<Bool, Rect<Float>>> = [
			for (x in 0...snapCellCounts.x + 1) new Pair(
				x % 4 == 0, new Rect<Float>(xbegin + x * snapCellSize.x, ybegin, xbegin + x * snapCellSize.x, ybegin + height)
			)
		];
		for (y in 0...snapCellCounts.y + 1) {
			r.push(new Pair(y % 4 == 0, new Rect<Float>(xbegin, ybegin + y * snapCellSize.y, xbegin + width, ybegin + y * snapCellSize.y)));
		}
		return r;
	}

	public function convertPoint(p: IntPoint): Point<Float> {
		return new Point(xbegin + p.x * snapCellSize.x, ybegin + p.y * snapCellSize.y);
	}

	public function dataFromIntPoint(p: IntPoint): DrawShapePointerData {
		return { x: xbegin + p.x * snapCellSize.x, y: ybegin + p.y * snapCellSize.y, col: p.x, row: p.y };
	}

	private function enableHandler(): Void {
		if (lastTouch != null) {
			overHandler(lastTouch);
		} else {
			touchable.onOver < overHandler;
		}
	}

	private function disableHandler(): Void {
		if (lastTouch != null) outHandler(lastTouch);
		touchable.onOver >> overHandler;
	}

	private function overHandler(t: Touch): Void {
		lastTouch = t;
		t.onMove << moveHandler;
		moveHandler(t);
		touchable.onOut < outHandler;
	}

	private function moveHandler(t: Touch): Void {
		eDrawPoint.dispatch({ x: t.x - xbegin, y: t.y - ybegin }, t);
	}

	private function outHandler(t: Touch): Void {
		hidePoint(t);
		touchable.onOut >> outHandler;
		t.onMove >> moveHandler;
		touchable.onOver < overHandler;
	}

	private function magnet(p: DrawShapePointerData, t: Touch): Bool {
		if (
			p.x > -snapCellSize.x / 2 && p.y > -snapCellSize.y / 2 && p.x < width + snapCellSize.x / 2 && p.y < height + snapCellSize.y / 2
		) {
			p.col = Math.ceil(p.x / snapCellSize.x - 0.5);
			p.row = Math.ceil(p.y / snapCellSize.y - 0.5);
			p.x = xbegin + p.col * snapCellSize.x;
			p.y = ybegin + p.row * snapCellSize.y;
			return false;
		}
		hidePoint(t);
		return true;
	}

	private function drawPointHandler(p: DrawShapePointerData, t: Touch): Void {
		downPointData = p;
		t.onDown << downHandler;
	}

	private function hidePointHandler(t: Touch): Void {
		downPointData = null;
		t.onDown >> downHandler;
	}

	private function downHandler(t: Touch): Void {
		eDownPoint.dispatch(downPointData, t);
	}

}
