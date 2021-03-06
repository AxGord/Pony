package pony.ui.gui;

import pony.geom.Rect;
import pony.geom.Point;

/**
 * GridCore
 * @author AxGord
 */
class GridCore {

	public var slotWidth(default, null): Float;
	public var slotHeight(default, null): Float;
	public var gap: Float;
	public var cx(default, null): Int;
	public var cy(default, null): Int;
	public var totalWidth(default, null): Float;
	public var totalHeight(default, null): Float;

	private var slots: Array<Array<Bool>>;

	private static var searchWay: Array<IntPoint> = [
		{ x: 0, y: 0 }, { x: 1, y: 0 }, { x: 0, y: 1 }, { x: -1, y: 0 }, { x: 0, y: -1 },
		{ x: 1, y: 1 }, { x: -1, y: 1 }, { x: -1, y: -1 }, { x: 1, y: -1 },
		{ x: 2, y: -1 }, { x: 2, y: 0 }, { x: 2, y: 1 }, { x: 2, y: 2 }, { x: 1, y: 2 }, { x: 0, y: 2 }, { x: -1, y: 2 },
		{ x: -2, y: 2 }, { x: -2, y: 1 }, { x: -2, y: 0 }, { x: -2, y: -1}, { x: -2, y: -2 },
		{ x: -1, y: -2 }, { x: 0, y: -2 }, { x: 1, y: -2 }, { x: -2, y: -2 }
	];

	public inline function new(width: Float, height: Float, gap: Float = 10) {
		slotWidth = width;
		slotHeight = height;
		this.gap = gap;
	}

	public inline function setTotal(width: Float, height: Float): Void {
		totalWidth = width;
		totalHeight = height;
		cx = Math.ceil(width / slotWidth) - 1;
		cy = Math.ceil(height / slotHeight) - 1;
		slots = [ for (_ in 0...cy) [ for (_ in 0...cx) false ] ];
	}

	public inline function intRect(rect: Rect<Float>): Rect<Int> return {
			x: Math.floor((rect.x + slotWidth / 2) / slotWidth),
			y: Math.floor((rect.y + slotHeight / 2) / slotHeight),
			width: Math.ceil((rect.width - gap) / slotWidth),
			height: Math.ceil((rect.height - gap) / slotHeight)
		};

	public inline function intPoint(rect: Rect<Float>): Point<Int> return {
			x: Math.floor((rect.x + slotWidth / 2) / slotWidth),
			y: Math.floor((rect.y + slotHeight / 2) / slotHeight)
		};

	public inline function floatRect(rect: Rect<Int>): Rect<Float> return {
		x: rect.x * slotWidth,
		y: rect.y * slotHeight,
		width: slotWidth * rect.width,
		height: slotHeight * rect.height
	};

	public inline function floatPoint(rect: Point<Int>): Point<Float> return {
		x: rect.x * slotWidth,
		y: rect.y * slotHeight
	};

	public dynamic function makeMark(y: Int, x: Int, state: Bool): Void {}

	public function mark(rect: Rect<Float>): Void {
		markOff();
		var r: Rect<Int> = intRect(rect);
		if (isOut(r)) return;
		for (i in r.y...r.y + r.height) for (j in r.x...r.x + r.width) makeMark(i, j, true);
	}

	public function markOff(): Void for (a in 0...cy) for (b in 0...cx) makeMark(a, b, false);

	public inline function isOut(r: Rect<Int>): Bool return r.x < 0 || r.x + r.width >= cx || r.y < 0 || r.y + r.height >= cy;

	public inline function isOutPoint(r: Point<Int>): Bool return r.x < 0 || r.x >= cx || r.y < 0 || r.y >= cy;

	public inline function isOutFloat(r: Rect<Float>): Bool return isOut(intRect(r));

	public inline function gx(r: Rect<Int>): Float return r.x * slotWidth;
	public inline function gy(r: Rect<Int>): Float return r.y * slotHeight;

	public inline function takePos(rect: Rect<Float>, mark: Bool = true): Rect<Int> return takePosInt(intRect(rect), mark);

	public function freePos(r: Rect<Int>): Void {
		for (y in r.y...r.y + r.height) for (x in r.x...r.x + r.width) {
			slots[y][x] = false;
			makeMark(y, x, false);
		}
	}

	public function takePosInt(start: IntRect, mark: Bool = true): Rect<Int> {
		for (d in searchWay) {
			var r: Rect<Int> = start + d;
			if (isOut(r)) continue;
			var taked: Bool = false;
			for (y in r.y...r.y + r.height) for (x in r.x...r.x + r.width) if (slots[y][x]) {
				taked = true;
				break;
			}
			if (taked) continue;

			for (y in r.y...r.y + r.height) for (x in r.x...r.x + r.width) {
				slots[y][x] = true;
				if (mark) makeMark(y, x, true);
			}

			return r;
		}
		return null;
	}

}