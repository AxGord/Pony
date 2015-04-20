/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.geom;

/**
 * GeomTools
 * @author AxGord
 */
class GeomTools 
{
	
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
			if ((((yp[i]<=y) && (y<yp[j])) || ((yp[j]<=y) && (y<yp[i]))) &&
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
	
	inline public static function rectInPoly<T:Float>(rect:Rect<T>, poly:Polygon<T>):Int {
		return countInPoly(rectToPoints(rect), poly);
	}
	
	inline public static function rectToPoints<T:Float>(rect:Rect<T>):Array<Point<T>> {
		return [
			new Point<T>(rect.x, rect.y),
			new Point<T>(rect.x+rect.width, rect.y),
			new Point<T>(rect.x+rect.width, rect.y+rect.height),
			new Point<T>(rect.x, rect.y+rect.height)
		];
	}
	
}
//todo:
//abstract _Poly<T>(Pair<Array<T>>, Point<Array<T>>>)