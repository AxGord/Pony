package pony.geom;

import pony.geom.Align.HAlign;
import pony.geom.Align.VAlign;
import pony.geom.Point.IntPoint;

/**
 * GeomTools
 * @author AxGord <axgord@gmail.com>
 */
class GeomTools {

	public static inline function rectInPoly<T:Float>(rect: Rect<T>, poly: Polygon<T>): Int {
		return countInPoly(rectToPoints(rect), poly);
	}

	public static inline function rectToPoints<T:Float>(rect: Rect<T>): Array<Point<T>> {
		return [
			new Point<T>(rect.x, rect.y),
			new Point<T>(rect.x + rect.width, rect.y),
			new Point<T>(rect.x + rect.width, rect.y + rect.height),
			new Point<T>(rect.x, rect.y + rect.height)
		];
	}

	public static function inPoly<T:Float>(point: Point<T>, poly: Polygon<T>): Bool {
		final xp = [];
		final yp = [];
		// Maybe use poly direct?
		for (p in poly) {
			xp.push(p.x);
			yp.push(p.y);
		}
		final x: T = point.x;
		final y: T = point.y;
		final npol: Int = xp.length;
		var j: Int = npol - 1;
		var c: Bool = false;
		for (i in 0...npol) {
			if (
				(((yp[i] <= y) && (y < yp[j])) || ((yp[j] <= y) && (y < yp[i])))
				&& (x > (xp[j] - xp[i]) * (y - yp[i]) / (yp[j] - yp[i]) + xp[i])
			) {
				c = !c;
			}
			j = i;
		}
		return c;
	}

	public static function countInPoly<T:Float>(points: Array<Point<T>>, poly: Polygon<T>): Int {
		var i: Int = 0;
		for (p in points) if (inPoly(p, poly)) i++;
		return i;
	}

	public static function center(
		container: Point<Float>, objects: Array<Point<Float>>, vert: Bool = false, ?border: Border<Int>, padding: Bool = true,
		?align: Align
	): Array<Point<Float>> {
		align = align != null ? align.defaultCenter : Align.createDefaultCenter();
		final cfun: (size:Float, objects:Array<Float>) -> Array<Float> = if (align != null) {
			if (vert)
				switch align.horizontal {
					case HAlign.Left: begin;
					case HAlign.Center: centerA;
					case HAlign.Right: end;
				}
			else
				switch align.vertical {
					case VAlign.Top: begin;
					case VAlign.Middle: centerA;
					case VAlign.Bottom: end;
				}
		} else
			centerA;
		final _fc: (size:Float, objects:Array<Float>) -> Array<Float> = !padding && objects.length > 1 ? centerC : centerB;
		final fc: (size:Float, objects:Array<Float>) -> Array<Float> = if (align != null) {
			if (vert)
				switch align.vertical {
					case VAlign.Top: begin;
					case VAlign.Middle: _fc;
					case VAlign.Bottom: end;
				}
			else
				switch align.horizontal {
					case HAlign.Left: begin;
					case HAlign.Center: _fc;
					case HAlign.Right: end;
				}
		} else
			_fc;

		final fa: (size:Float, objects:Array<Float>) -> Array<Float> = vert ? cfun : fc;
		final fb: (size:Float, objects:Array<Float>) -> Array<Float> = vert ? fc : cfun;
		if (border == null) border = 0;
		final w: Float = container.x - (border.left + border.right);
		final h: Float = container.y - (border.top + border.bottom);
		final a: Array<Float> = fa(w, [for (obj in objects) obj.x]);
		final b: Array<Float> = fb(h, [for (obj in objects) obj.y]);
		return [for (i in 0...a.length) new Point(a[i] + border.left, b[i] + border.top)];
	}

	public static function centerA(size: Float, objects: Array<Float>): Array<Float> {
		if (size == -1) for (obj in objects) if (obj > size) size = obj;
		return [for (obj in objects) (size - obj) / 2];
	}

	public static function centerB(size: Float, objects: Array<Float>): Array<Float> {
		var sum: Float = 0;
		for (obj in objects) sum += obj;
		final d: Float = (size - sum) / (objects.length + 1);
		var pos: Float = d;
		final r = [];
		for (obj in objects) {
			r.push(pos);
			pos += obj + d;
		}
		return r;
	}

	public static function centerC(size: Float, objects: Array<Float>): Array<Float> {
		var sum: Float = 0;
		for (obj in objects) sum += obj;
		final d: Float = (size - sum) / (objects.length - 1);
		var pos: Float = 0;
		final r = [];
		for (obj in objects) {
			r.push(pos);
			pos += obj + d;
		}
		return r;
	}

	public static function begin(size: Float, objects: Array<Float>): Array<Float> return [for (_ in objects) 0];

	public static function end(size: Float, objects: Array<Float>): Array<Float> {
		if (size == -1) for (obj in objects) if (obj > size) size = obj;
		return [for (obj in objects) size - obj];
	}

	public static function valign(a: VAlign, size: Float, objects: Array<Float>): Array<Float> {
		return switch a {
			case VAlign.Top: [for (_ in objects) 0];
			case VAlign.Middle: centerA(size, objects);
			case VAlign.Bottom: end(size, objects);
		}
	}

	public static function halign(a: HAlign, size: Float, objects: Array<Float>): Array<Float> {
		return switch a {
			case HAlign.Left: [for (_ in objects) 0];
			case HAlign.Center: centerA(size, objects);
			case HAlign.Right: end(size, objects);
		}
	}

	public static function pointsCeil(a: Array<Point<Float>>): Array<IntPoint> {
		return [for (p in a) new IntPoint(Std.int(p.x), Std.int(p.y))];
	}

}

// todo: abstract _Poly<T>(Pair<Array<T>>, Point<Array<T>>>)
