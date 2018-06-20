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
package pony.geom.drawshape;

import pony.geom.Rect;
import pony.ui.touch.Touchable;
import pony.ui.touch.Touch;
import pony.geom.Point;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.time.DeltaTime;

/**
 * DrawShapePointer
 * @author AxGord <axgord@gmail.com>
 */
class DrawShapePointer extends pony.Tumbler {

	private static inline var PRIORITY:Int = -10;
	
	@:auto public var onDrawPoint:Signal2<DrawShapePointerData, Touch>;
	@:auto public var onHidePoint:Signal1<Touch>;
	@:auto public var onDownPoint:Signal2<DrawShapePointerData, Touch>;

	private var touchable:Touchable;

	private var width:Float;
	private var height:Float;
	public var xbegin(default, null):Float = 0;
	public var ybegin(default, null):Float = 0;
	public var snapCellCounts(default, null):Point<Int> = new Point<Int>(12, 12);
	public var snapCellSize(default, null):Point<Float>;
	private var downPointData:DrawShapePointerData;

	private var lastTouch:Touch;

	public function new(touchable:Touchable, width:Float, height:Float, ?snapCellCounts:Point<Int>) {
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
		if (snapCellCounts != null)
			this.snapCellCounts = snapCellCounts;
		snapCellSize = new Point(width / this.snapCellCounts.x, height / this.snapCellCounts.y);
		onDrawPoint.add(magnet, PRIORITY);
		onDrawPoint.add(drawPointHandler, PRIORITY);
		onHidePoint.add(hidePointHandler, PRIORITY);
		onEnable << enableHandler;
		onDisable << disableHandler;
	}

	public function drawSnap():Array<Pair<Bool, Rect<Float>>> {
		var r:Array<Pair<Bool, Rect<Float>>> = [];
		for (x in 0...snapCellCounts.x + 1) {
			r.push(new Pair(x % 4 == 0, new Rect<Float>(xbegin + x * snapCellSize.x, ybegin, xbegin + x * snapCellSize.x, ybegin + height)));
		}
		for (y in 0...snapCellCounts.y + 1) {
			r.push(new Pair(y % 4 == 0, new Rect<Float>(xbegin, ybegin + y * snapCellSize.y, xbegin + width, ybegin + y * snapCellSize.y)));			
		}
		return r;
	}

	public function convertPoint(p:IntPoint):Point<Float> {
		return new Point(xbegin + p.x * snapCellSize.x, ybegin + p.y * snapCellSize.y);
	}

	private function enableHandler():Void {
		if (lastTouch != null) {
			overHandler(lastTouch);
		} else {
			touchable.onOver < overHandler;
		}
	}

	private function disableHandler():Void {
		if (lastTouch != null)
			outHandler(lastTouch);
		touchable.onOver >> overHandler;
	}

	private function overHandler(t:Touch):Void {
		lastTouch = t;
		t.onMove << moveHandler;
		moveHandler(t);
		touchable.onOut < outHandler;
	}

	private function moveHandler(t:Touch):Void {
		eDrawPoint.dispatch({
			x: t.x - xbegin,
			y: t.y - ybegin
		}, t);
	}

	private function outHandler(t:Touch):Void {
		hidePoint(t);
		touchable.onOut >> outHandler;
		t.onMove >> moveHandler;
		touchable.onOver < overHandler;
	}

	public function hidePoint(t:Touch):Void eHidePoint.dispatch(t);

	private function magnet(p:DrawShapePointerData, t:Touch):Bool {
		if (p.x > -snapCellSize.x / 2 && p.y > -snapCellSize.y / 2 && p.x < width + snapCellSize.x / 2 && p.y < height + snapCellSize.y / 2) {
			p.col = Math.ceil(p.x / snapCellSize.x - 0.5);
			p.row = Math.ceil(p.y / snapCellSize.y - 0.5);
			p.x = xbegin + p.col * snapCellSize.x;
			p.y = ybegin + p.row * snapCellSize.y;
			return false;
		} else {
			hidePoint(t);
			return true;
		}
	}

	public function dataFromIntPoint(p:IntPoint):DrawShapePointerData {
		return {
			x: xbegin + p.x * snapCellSize.x,
			y: ybegin + p.y * snapCellSize.y,
			col: p.x,
			row: p.y
		};
	}
	
	private function drawPointHandler(p:DrawShapePointerData, t:Touch):Void {
		downPointData = p;
		t.onDown << downHandler;
	}

	private function hidePointHandler(t:Touch):Void {
		downPointData = null;
		t.onDown >> downHandler;
	}

	private function downHandler(t:Touch):Void {
		eDownPoint.dispatch(downPointData, t);
	}

}