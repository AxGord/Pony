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
package pony.geom;

import pony.geom.Align.HAlign;
import pony.geom.Align.VAlign;
import pony.geom.Point.IntPoint;

/**
 * GeomTools
 * @author AxGord
 */
class GeomTools {
	
	public static function inPoly<T:Float>(point:Point<T>, poly:Polygon<T>):Bool {
		var xp = [];
		var yp = [];
		//Maybe use poly direct?
		for (p in poly) {
			xp.push(p.x);
			yp.push(p.y);
		}
		var x = point.x;
		var y = point.y;
		var npol = xp.length;
		var j = npol - 1;
		var c = false;
		for (i in 0...npol){
			if ((((yp[i] <= y) && (y < yp[j])) || ((yp[j] <= y) && (y < yp[i]))) &&
				(x > (xp[j] - xp[i]) * (y - yp[i]) / (yp[j] - yp[i]) + xp[i])) {
				c = !c;
			}
			j = i;
		}
		return c;
	}
	
	public static function countInPoly<T:Float>(points:Array<Point<T>>, poly:Polygon<T>):Int {
		var i:Int = 0;
		for (p in points) if (inPoly(p, poly)) i++;
		return i;
	}
	
	public static inline function rectInPoly<T:Float>(rect:Rect<T>, poly:Polygon<T>):Int {
		return countInPoly(rectToPoints(rect), poly);
	}
	
	public static inline function rectToPoints<T:Float>(rect:Rect<T>):Array<Point<T>> {
		return [
			new Point<T>(rect.x, rect.y),
			new Point<T>(rect.x + rect.width, rect.y),
			new Point<T>(rect.x + rect.width, rect.y + rect.height),
			new Point<T>(rect.x, rect.y + rect.height)
		];
	}
	
	public static function center(
		container:Point<Float>,
		objects:Array<Point<Float>>,
		vert:Bool = false,
		?border:Border<Int>,
		padding:Bool = true,
		?align:Align
	):Array<Point<Float>> {
		var cfun = if (align != null)  {
			if (vert) switch align.horizontal {
				case HAlign.Left: begin;
				case HAlign.Center: centerA;
				case HAlign.Right: end;
			} else switch align.vertical {
				case VAlign.Top: begin;
				case VAlign.Middle: centerA;
				case VAlign.Bottom: end;
			}
		} else centerA;
		var _fc = !padding && objects.length > 1 ? centerC : centerB;
		var fc =  if (align != null)  {
			if (!vert) switch align.horizontal {
				case HAlign.Left: begin;
				case HAlign.Center: _fc;
				case HAlign.Right: end;
			} else switch align.vertical {
				case VAlign.Top: begin;
				case VAlign.Middle: _fc;
				case VAlign.Bottom: end;
			}
		} else _fc;
		
		var fa = vert ? cfun : fc;
		var fb = vert ? fc : cfun;
		if (border == null) border = 0;
		var w = container.x - (border.left + border.right);
		var h = container.y - (border.top + border.bottom);
		var a = fa(w, [for (obj in objects) obj.x]);
		var b = fb(h, [for (obj in objects) obj.y]);
		return [for (i in 0...a.length) new Point(a[i] + border.left, b[i] + border.top)];
	}
	
	public static function centerA(size:Float, objects:Array<Float>):Array<Float> {
		if (size == -1) for (obj in objects) if (obj > size) size = obj;
		return [for (obj in objects) (size - obj) / 2];
	}
	
	public static function centerB(size:Float, objects:Array<Float>):Array<Float> {
		var sum:Float = 0;
		for (obj in objects) sum += obj;
		var d:Float = (size - sum) / (objects.length + 1);
		var pos:Float = d;
		var r = [];
		for (obj in objects) {
			r.push(pos);
			pos += obj + d;
		}
		return r;
	}
	
	public static function centerC(size:Float, objects:Array<Float>):Array<Float> {
		var sum:Float = 0;
		for (obj in objects) sum += obj;
		var d:Float = (size - sum) / (objects.length - 1);
		var pos:Float = 0;
		var r = [];
		for (obj in objects) {
			r.push(pos);
			pos += obj + d;
		}
		return r;
	}
	
	public static function begin(size:Float, objects:Array<Float>):Array<Float> return [for (_ in objects) 0];
	
	public static function end(size:Float, objects:Array<Float>):Array<Float> {
		if (size == -1) for (obj in objects) if (obj > size) size = obj;
		return [for (obj in objects) size - obj];
	}
	
	public static function valign(a:VAlign, size:Float, objects:Array<Float>):Array<Float> {
		return switch a {
			case VAlign.Top: [for (_ in objects) 0];
			case VAlign.Middle: centerA(size, objects);
			case VAlign.Bottom: end(size, objects);
		}
	}
	
	public static function halign(a:HAlign, size:Float, objects:Array<Float>):Array<Float> {
		return switch a {
			case HAlign.Left: [for (_ in objects) 0];
			case HAlign.Center: centerA(size, objects);
			case HAlign.Right: end(size, objects);
		}
	}
	
	public static function pointsCeil(a:Array<Point<Float>>):Array<IntPoint> {
		return [for (p in a) new IntPoint(Std.int(p.x), Std.int(p.y))];
	}
	
}
//todo:
//abstract _Poly<T>(Pair<Array<T>>, Point<Array<T>>>)