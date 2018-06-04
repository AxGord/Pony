/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package pony.pixi.ui;

import pony.ui.touch.Touchable;
import pony.geom.Point;
import pony.geom.drawshape.DrawShape;
import pony.geom.drawshape.DrawShapePointer;
import pony.geom.drawshape.DrawShapePointerData;
import pony.events.Signal2;
import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;

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

	public var size(get, never):Point<Int>;
	private var _size:Point<Int>;
	public var bgLayer(default, null):Sprite = new Sprite();
	public var snapLayer(default, null):Sprite = new Sprite();
	public var drawLayer(default, null):Sprite = new Sprite();
	public var tmpDrawLayer(default, null):Sprite = new Sprite();
	public var pointerLayer(default, null):Sprite = new Sprite();
	public var mainLayer(default, null):Sprite = new Sprite();

	private var touchable:Touchable;
	private var ds:DrawShape;
	private var dsp:DrawShapePointer;
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

		this.touchable = new Touchable(bgLayer);

		mainLayer.addChild(bgLayer);
		mainLayer.addChild(snapLayer);
		mainLayer.addChild(drawLayer);
		addChild(mainLayer);
		addChild(tmpDrawLayer);
		addChild(pointerLayer);

		snapLayer.interactive = false;
		drawLayer.interactive = false;
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
		snap.lineStyle(LINE_WIDTH, SNAP_LINE_COLOR);
		for (r in dsp.drawSnap(LINE_WIDTH)) {
			snap.moveTo(r.x, r.y);
			snap.lineTo(r.width, r.height);
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

	public function destroyIWH():Void {
		destroy();
	}

	public function get_size():Point<Int> {
		return _size;
	}

	public function wait(fn:Void -> Void):Void {
		fn();
	}
	
}