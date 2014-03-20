/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.ui;

import pony.geom.Rect;
import pony.geom.Point;

/**
 * ...
 * @author AxGord
 */
class GridCore {
	
	public var slotWidth(default,null):Float;
	public var slotHeight(default,null):Float;
	public var gap:Float;
	public var cx(default,null):Int;
	public var cy(default,null):Int;
	public var totalWidth(default,null):Float;
	public var totalHeight(default,null):Float;
	
	private var slots:Array<Array<Bool>>;
	
	private static var searchWay:Array<IntPoint> = [
		{ x:0, y:0 }, { x:1, y:0 }, { x:0, y:1 }, { x: -1, y:0 }, { x:0, y: -1 },
		{ x:1, y:1 }, { x: -1, y:1 }, { x: -1, y: -1 }, { x: 1, y: -1 },
		{ x:2, y: -1 }, { x:2, y:0 }, { x:2, y:1 }, { x:2, y:2 }, { x:1, y:2 }, { x:0, y:2 }, { x: -1, y:2 },
		{ x:-2,y:2 }, { x:-2,y:1 }, { x:-2,y:0 }, { x:-2,y:-1}, { x:-2,y:-2 }, { x:-1,y:-2 }, { x:0,y:-2 }, { x:1,y:-2 }, { x:-2,y:-2 } 
	];

	public inline function new(width:Float, height:Float, gap:Float = 10) {
		slotWidth = width;
		slotHeight = height;
		this.gap = gap;
	}
	
	public inline function setTotal(width:Float, height:Float):Void {
		totalWidth = width;
		totalHeight = height;
		cx = Math.ceil(width/slotWidth) - 1;
		cy = Math.ceil(height / slotHeight) - 1;
		slots = [for(_ in 0...cy)[for(_ in 0...cx)false]];
	}
	
	public inline function intRect(rect:Rect<Float>):Rect<Int> return {
			x: Math.floor((rect.x + slotWidth / 2) / slotWidth),
			y: Math.floor((rect.y + slotHeight / 2) / slotHeight),
			width: Math.ceil((rect.width - gap) / slotWidth),
			height: Math.ceil((rect.height - gap) / slotHeight)
		};
	
	public inline function intPoint(rect:Rect<Float>):Point<Int> return {
			x: Math.floor((rect.x + slotWidth / 2) / slotWidth),
			y: Math.floor((rect.y + slotHeight / 2) / slotHeight)
		};
		
	public inline function floatRect(rect:Rect<Int>):Rect<Float> return {
		x: rect.x * slotWidth,
		y: rect.y * slotHeight,
		width: slotWidth * rect.width,
		height: slotHeight * rect.height
	};
	
	public inline function floatPoint(rect:Point<Int>):Point<Float> return {
		x: rect.x * slotWidth,
		y: rect.y * slotHeight
	};
	
	public dynamic function makeMark(y:Int, x:Int, state:Bool) { }
	
	public function mark(rect:Rect<Float>):Void {
		markOff();
		var r:Rect<Int> = intRect(rect);
		if (isOut(r)) return;
		for (i in r.y...r.y+r.height) for (j in r.x...r.x+r.width) makeMark(i, j, true);
	}
	
	public function markOff():Void for (a in 0...cy) for (b in 0...cx) makeMark(a, b, false);
	
	public inline function isOut(r:Rect<Int>):Bool return r.x < 0 || r.x+r.width >= cx || r.y < 0 || r.y+r.height >= cy;
	
	public inline function isOutPoint(r:Point<Int>):Bool return r.x < 0 || r.x >= cx || r.y < 0 || r.y >= cy;
	
	public inline function isOutFloat(r:Rect<Float>):Bool return isOut(intRect(r));
	
	public inline function gx(r:Rect<Int>):Float return r.x * slotWidth;
	public inline function gy(r:Rect<Int>):Float return r.y * slotHeight;
	
	public inline function takePos(rect:Rect<Float>, mark:Bool=true):Rect<Int> return takePosInt(intRect(rect), mark);
	
	public function freePos(r:Rect<Int>):Void {
		for (y in r.y...r.y + r.height) for (x in r.x...r.x + r.width) {
			slots[y][x] = false;
			makeMark(y, x, false);
		}
	}
	
	public function takePosInt(start:IntRect, mark:Bool=true):Rect<Int> {
		for (d in searchWay) {
			var r:Rect<Int> = start + d;
			if (isOut(r)) continue;
			var taked:Bool = false;
			for (y in r.y...r.y+r.height) for (x in r.x...r.x+r.width) if (slots[y][x]) {
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