package pony.pixi.ui;

import pony.ui.touch.Touchable;
import pony.geom.Point;
import pony.geom.drawshape.DrawShape;
import pony.geom.drawshape.DrawShapePointer;
import pony.geom.drawshape.DrawShapePointerData;
import pony.events.Signal1;
import pony.events.Signal2;
import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;
import pony.time.DeltaTime;

// typedef DrawShapeStyle = {
// 	snapWidth: Float
// }

/**
 * DrawShapeView
 * @author AxGord <axgord@gmail.com>
 */
class DrawShapeView extends LogableSprite implements pony.geom.IWH {

	public static inline var SNAP_LINE_WIDTH:Int = 4;
	public static inline var SNAP_LINE_COLOR:Int = 0x2F2F2F;

	public static inline var LINE_WIDTH:Int = 4;
	public static inline var LINE_PROCESS_COLOR:Int = 0xFFFFFF;
	public static inline var LINE_SHAPE_COLOR:Int = 0x82AAF7;

	public var size(get, never):Point<Float>;
	private var _size:Point<Int>;
	public var touchArea(default, null):Sprite = new Sprite();
	public var bgLayer(default, null):Sprite = new Sprite();
	public var snapLayer(default, null):Sprite = new Sprite();
	public var drawLayer(default, null):Sprite = new Sprite();
	public var tmpDrawLayer(default, null):Sprite = new Sprite();
	public var pointerLayer(default, null):Sprite = new Sprite();
	public var mainLayer(default, null):Sprite = new Sprite();

	private var touchable:Touchable;
	public var ds(default, null):DrawShape;
	public var dsp(default, null):DrawShapePointer;
	public var dpivot(default, null):DrawShapePivot;
	private var snap:Graphics = new Graphics();
	public var resultLines(default, null):Graphics = new Graphics();
	public var polyLines(default, null):Graphics = new Graphics();
	public var shapes(default, null):Graphics = new Graphics();
	public var pathLine(default, null):Graphics = new Graphics();
	private var startPoint:Graphics = new Graphics();
	private var endPoint:Graphics = new Graphics();

	public var finalShapes:Array<Graphics> = [];

	public function new(size:Point<Int>) {
		super();
		_size = size;

		addChild(touchArea);
		mainLayer.addChild(bgLayer);
		mainLayer.addChild(snapLayer);
		mainLayer.addChild(drawLayer);
		addChild(mainLayer);
		addChild(tmpDrawLayer);
		addChild(pointerLayer);

		this.touchable = new Touchable(touchArea);

		mainLayer.interactive = false;
		tmpDrawLayer.interactive = false;
		pointerLayer.interactive = false;

		dsp = new DrawShapePointer(touchable, size.x - LINE_WIDTH, size.y - LINE_WIDTH);
		dsp.onDrawPoint << drawPointHandler;
		dsp.onHidePoint << hidePointHandler;
		ds = new DrawShape(dsp);
		ds.onLog << log;
		ds.onError << error;
		ds.onPathBegin << pathBeginHandler;
		ds.onPathCancel << pathCancelHandler;
		ds.onDrawFinishPolygon << unfreeze;
		ds.onDrawFinishPolygon << drawPolygon;
		ds.onDrawFinishPolygon << drawPolygonLines;
		ds.onDrawFinishPolygon << freeze;

		dpivot = new DrawShapePivot(dsp);

		resultLines.position.set(LINE_WIDTH / 2, LINE_WIDTH / 2);
		drawLayer.addChild(shapes);
		drawLayer.addChild(polyLines);
		drawLayer.addChild(resultLines);
		ds.onStoreDraw << storeDrawHandler;

		pathLine.position.set(LINE_WIDTH / 2, LINE_WIDTH / 2);
		tmpDrawLayer.addChild(pathLine);
		ds.onPathDraw << pathDrawHandler;
		ds.onPathDrawRemove << clearPathLine;
		ds.onStoreClear << clearStore;

		polyLines.position.set(LINE_WIDTH / 2, LINE_WIDTH / 2);
		shapes.position.set(LINE_WIDTH / 2, LINE_WIDTH / 2);

		createBackground();
		createPointers();
		drawSnap();
		disable();
		startPoint.visible = false;
		endPoint.visible = false;
	}

	private function createBackground():Void {
		var bg = new Graphics();
		bg.beginFill(0x212121);
		if (size.x > size.y)
			bg.drawRect(dsp.xbegin, 0, size.y, size.y);
		else
			bg.drawRect(0, dsp.ybegin, size.x, size.x);
		bgLayer.addChild(bg);

		var tg = new Graphics();
		tg.beginFill(0, 0);
		if (size.x > size.y)
			tg.drawRect(dsp.xbegin - dsp.snapCellSize.x, -dsp.snapCellSize.y, size.y + dsp.snapCellSize.x * 2, size.y + dsp.snapCellSize.y * 2);
		else
			tg.drawRect(-dsp.snapCellSize.x, dsp.ybegin - dsp.snapCellSize.y, size.x + dsp.snapCellSize.x * 2, size.x + dsp.snapCellSize.y * 2);
		touchArea.addChild(tg);
	}

	private function createPointers():Void {
		startPoint.beginFill(0xF78C6C);
		startPoint.drawCircle(0, 0, 20);
		pointerLayer.addChild(startPoint);
		endPoint.beginFill(0xFF5577);
		endPoint.drawCircle(0, 0, 20);
		pointerLayer.addChild(endPoint);
	}

	private function drawSnap():Void {
		snap.position.set(LINE_WIDTH / 2, LINE_WIDTH / 2);
		for (r in dsp.drawSnap()) {
			snap.lineStyle(LINE_WIDTH * (r.a ? 2 : 1), SNAP_LINE_COLOR);
			snap.moveTo(r.b.x, r.b.y);
			snap.lineTo(r.b.width, r.b.height);
		}
		snapLayer.addChild(snap);
	}

	public function enable():Void {
		ds.enable();
		visible = true;
	}

	public function disable():Void {
		ds.disable();
		visible = false;
		pathCancelHandler();
		hidePointHandler();
	}

	private function drawPointHandler(p:DrawShapePointerData):Void {
		endPoint.position.set(p.x, p.y);
		endPoint.visible = true;
	}

	private function hidePointHandler():Void {
		endPoint.visible = false;
	}

	private function pathBeginHandler(p:DrawShapePointerData):Void {
		startPoint.position.set(p.x, p.y);
		startPoint.visible = true;
	}

	private function pathCancelHandler():Void startPoint.visible = false;

	private function clearPathLine():Void pathLine.clear();

	private function clearStore():Void {
		unfreeze();
		resultLines.clear();
		freeze();
	}

	private function pathDrawHandler(a:DrawShapePointerData, b:DrawShapePointerData):Void {
		pathLine.lineStyle(LINE_WIDTH, LINE_PROCESS_COLOR);
		pathLine.moveTo(a.x, a.y);
		pathLine.lineTo(b.x, b.y);
	}

	private function storeDrawHandler(a:DrawShapePointerData, b:DrawShapePointerData):Void {
		mainLayer.cacheAsBitmap = false;
		resultLines.lineStyle(LINE_WIDTH, LINE_SHAPE_COLOR);
		resultLines.moveTo(a.x, a.y);
		resultLines.lineTo(b.x, b.y);
		mainLayer.cacheAsBitmap = true;
	}

	private function unfreeze():Void {
		mainLayer.cacheAsBitmap = false;
	}

	private function freeze():Void {
		mainLayer.cacheAsBitmap = true;
	}

	private function drawPolygon(polygon:Array<Float>):Void {
		shapes.beginFill(0x89DDFF, 0.5);
		shapes.drawPolygon(polygon);
	}

	private function drawPolygonLines(polygon:Array<Float>):Void {
		polyLines.lineStyle(LINE_WIDTH, LINE_SHAPE_COLOR);
		polyLines.drawPolygon(polygon);
	}

	public function pivotMode():Void {
		ds.disable();
		dpivot.start();
	}

	public function reset():Void {
		dpivot.reset();
		unfreeze();
		ds.reset();
		resultLines.clear();
		polyLines.clear();
		shapes.clear();
		freeze();
	}

	public function destroyIWH():Void {
		destroy();
	}

	public function get_size():Point<Float> {
		return _size;
	}

	public function wait(fn:Void -> Void):Void {
		fn();
	}
	
}

class DrawShapePivot implements pony.magic.HasSignal {

	@:auto public var onPivot:Signal1<Point<Int>>;

	private var pointer:DrawShapePointer;

	public function new(pointer:DrawShapePointer) {
		this.pointer = pointer;
	}

	public function start():Void {	
		DeltaTime.fixedUpdate < pointer.enable;
		pointer.onDownPoint < downPointHandler;
	}

	public function reset():Void {
		pointer.onDownPoint >> downPointHandler;
	}

	private function downPointHandler(p:DrawShapePointerData):Void {
		ePivot.dispatch(new Point<Int>(p.col, p.row));
	}

}