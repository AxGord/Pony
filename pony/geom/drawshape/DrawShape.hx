package pony.geom.drawshape;

import pony.geom.Point;
import pony.Byte;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.events.Event1;
import pony.ui.touch.Touch;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

/**
 * DrawShape
 * @author AxGord <axgord@gmail.com>
 */
class DrawShape extends pony.Logable {

	private static inline var PRIORITY:Int = -8;

	@:auto public var onPathBegin:Signal1<DrawShapePointerData>;
	@:auto public var onPathCancel:Signal0;
	@:auto public var onPathDraw:Signal2<DrawShapePointerData, DrawShapePointerData>;
	@:auto public var onPathDrawRemove:Signal0;
	@:auto public var onStoreDraw:Signal2<DrawShapePointerData, DrawShapePointerData>;
	@:auto public var onStoreClear:Signal0;

	@:auto public var onFinishShape:Signal1<Array<IntPoint>>;
	public var onDrawFinishShape(default, null):Signal1<Array<Point<Float>>>;
	public var onDrawFinishPolygon(default, null):Signal1<Array<Float>>;
	public var onFinishBinary:Signal1<Bytes>;

	private var pointer:DrawShapePointer;
	private var downPointData:DrawShapePointerData;
	private var downPointTouch:Touch;
	private var targetPointData:DrawShapePointerData;
	private var targetPointTouch:Touch;
	private var shape:Array<IntPoint> = [];

	public function new(pointer:DrawShapePointer) {
		super();
		this.pointer = pointer;
		onDrawFinishShape = onFinishShape.convert1(convertPoints);
		onDrawFinishPolygon = onDrawFinishShape.convert1(pointsToPolygon);
		onFinishBinary = onFinishShape.convert1(shapeToBytes);
	}

	public function reset():Void {
		shape = [];
	}

	public function enable():Void {
		log('enable draw shape');
		pointer.enable();
		addStartListeners();
	}

	public function disable():Void {
		log('disable draw shape');
		pointer.disable();
		removeDrawListeners();
		removeStartListeners();
	}

	private function convertPoints(e:Event1<Array<Point<Float>>>, p:Array<IntPoint>):Void {
		e.dispatch(p.map(pointer.convertPoint));
	}

	private function pointsToPolygon(e:Event1<Array<Float>>, p:Array<Point<Float>>):Void {
		var r:Array<Float> = [];
		for (v in p) {
			r.push(v.x);
			r.push(v.y);
		}
		r.push(p[0].x);
		r.push(p[0].y);
		e.dispatch(r);
	}

	private function shapeToBytes(e:Event1<Bytes>, p:Array<IntPoint>):Void {
		var b = new BytesOutput();
		for (v in p) b.writeByte(Byte.create(v.x, v.y));
		log('Bytes size: ' + b.length);
		e.dispatch(b.getBytes());
	}

	private function stopListenDownTouch():Void {
		if (downPointTouch != null) {
			stopListenDown(downPointTouch);
		}
	}

	private function addStartListeners():Void {
		pointer.onDrawPoint.add(startListenDown, PRIORITY);
		pointer.onHidePoint.add(stopListenDown, PRIORITY);
	}

	private function removeStartListeners():Void {
		stopListenDownTouch();
		pointer.onDrawPoint >> startListenDown;
		pointer.onHidePoint >> stopListenDown;
	}

	private function startListenDown(p:DrawShapePointerData, t:Touch):Void {
		stopListenDownTouch();
		downPointData = p;
		downPointTouch = t;
		t.onDown < downHandler;
	}

	private function stopListenDown(t:Touch):Void {
		downPointTouch = null;
		t.onDown >> downHandler;
	}

	private function downHandler(t:Touch):Void {
		clickHandler(t);
	}

	private function clickHandler(t:Touch):Void {
		removeStartListeners();
		writeShapePoint();
		ePathBegin.dispatch(downPointData);
		addDrawListeners();
	}

	private function stopDrawHandler(t:Touch):Void {
		removeDrawListeners();
		ePathCancel.dispatch();
		addStartListeners();
		startListenDown(targetPointData, t);
	}

	private function addDrawListeners():Void {
		pointer.onDrawPoint.add(drawPath, PRIORITY);
		pointer.onHidePoint.add(pathDrawRemove, PRIORITY);
	}

	private function removeDrawListeners():Void {
		pathDrawRemoveTouch();
		pointer.onDrawPoint >> drawPath;
		pointer.onHidePoint >> pathDrawRemove;
	}

	private function drawPath(p:DrawShapePointerData, t:Touch):Void {
		pathDrawRemove(t);
		targetPointData = p;
		targetPointTouch = t;
		ePathDraw.dispatch(downPointData, p);
		t.onDown < store;
	}

	private function pathDrawRemove(t:Touch):Void {
		targetPointTouch = null;
		t.onDown >> store;
		ePathDrawRemove.dispatch();
	}

	private function pathDrawRemoveTouch():Void {
		if (targetPointTouch != null)
			pathDrawRemove(targetPointTouch);
	}

	private function checkDeny(p1:IntPoint, p2:IntPoint):Bool {
		if (p2 == null) return false;

		if (p1.x == targetPointData.col && p1.y == targetPointData.row) return false;//allow for clear
		if (p2.x == targetPointData.col && p2.y == targetPointData.row) return true;

		if (eq3(p1.x, p2.x, targetPointData.col)) return true;
		if (eq3(p1.y, p2.y, targetPointData.row)) return true;

		var r1 = p1.x - p1.y;
		var r2 = p2.x - p2.y;
		var r3 = targetPointData.col - targetPointData.row;
		if (eq3(r1, r2, r3)) return true;
		var r1b = p1.x + p1.y;
		var r2b = p2.x + p2.y;
		var r3b = targetPointData.col + targetPointData.row;
		if (eq3(r1, r2, r3)) return true;
		for (i in 1...Std.int(pointer.snapCellCounts.x / 2)) {
			if ((r2 - r1) * i == r3 - r2 && (r2b - r1b) * i == r3b - r2b) return true;
			if ((r2 - r1) * i == r1 - r3 && (r2b - r1b) * i == r1b - r3b) return true;
		}
		// trace(r1, r2, r3);
		// trace(r1b, r2b, r3b);
		return false;
	}

	private function eq3<T>(a:T, b:T, c:T):Bool return a == b && b == c;

	private function store(t:Touch):Void {
		var psh:IntPoint = null;
		var sh:IntPoint = null;
		if (shape.length > 1) {

			if (shape.length > 2 && shape[0].x == targetPointData.col && shape[0].y == targetPointData.row) {
				ePathDrawRemove.dispatch();
				eStoreClear.dispatch();
				eFinishShape.dispatch(shape);
				shape = [];
				stopDrawHandler(t);
				return;
			}

			psh = shape.pop();
			sh = shape.pop();
			shape.push(sh);
		} else {
			psh = sh = shape.pop();
		}
		
		if (shape.length > 0 && checkDeny(sh, psh)) {
			// trace(sh, psh);
			// trace(targetPointData.col, targetPointData.row);
			// trace('Ignore click');
			shape.push(psh);
			return;
		}
		// if (sh != null) {
		// 	trace('------');
		// 	trace(targetPointData.col, targetPointData.row);
		// 	trace(sh);
		// }
		if (sh != null && sh.x == targetPointData.col && sh.y == targetPointData.row) {
			// trace('REMOVE');
			ePathDrawRemove.dispatch();
			downPointData = pointer.dataFromIntPoint(sh);
			eStoreClear.dispatch();
			if (shape.length <= 1) {
				shape = [];
				stopDrawHandler(t);
				return;
			}
			var prev:IntPoint = null;
			for (p in shape) {
				if (prev != null)
					eStoreDraw.dispatch(pointer.dataFromIntPoint(prev), pointer.dataFromIntPoint(p));
				prev = p;
			}
		} else {
			if (psh != null)
				shape.push(psh);
			eStoreDraw.dispatch(downPointData, targetPointData);
			downPointData = targetPointData;
			writeShapePoint();
		}
		ePathBegin.dispatch(downPointData);
	}

	private function writeShapePoint():Void {
		var p = new IntPoint(downPointData.col, downPointData.row);
		log('Write shape point: $p');
		shape.push(p);
	}
	
}