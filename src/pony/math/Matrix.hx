package pony.math;

import pony.geom.Point;

/**
 * Matrix
 * @author AxGord <axgord@gmail.com>
 */
@:forward(push, pop, length) @:nullSafety(Strict)
abstract Matrix<T>(Array<Array<T>>) from Array<Array<T>> to Array<Array<T>> {

	public function cut(x: Int, y: Int): Matrix<T> return [ for (i in 0...y) [ for (j in 0...x) this[i][j] ] ];

	public function hor(d: Int): Matrix<T> {
		return if (d > 0)
			[ for (e in this) [ for (i in 0...e.length) if (i + d < e.length) e[i + d] else e[i + d - e.length] ] ];
		else if (d < 0)
			[ for (e in this) [ for (i in 0...e.length) if (i + d >= 0) e[i + d] else e[i + d + e.length] ] ];
		else this;
	}

	/**
	 * Parse integer matrix from text
	 * 0 > value > 9
	 */
	public static function parse(text: String): Matrix<Int> {
		var result: Matrix<Int> = [];
		var row: Array<Int> = [];
		var x: Int = 0;
		var y: Int = 0;
		for (i in 0...text.length) {
			var c: String = text.charAt(i);
			if (c == '\n') {
				y++;
				x = 0;
				result.push(row);
				row = [];
			} else {
				var p: Null<Int> = Std.parseInt(c);
				row.push(p != null && p > 0 ? p : 0);
			}
		}
		if (row.length > 0) result.push(row);
		return result;
	}

	/**
	 * Creates a new List by applying function `f` to all matrix elements.
	 * The order of elements is preserved.
	**/
	public function map<B>(f: T -> B): Matrix<B> return [ for (y in this) [ for (x in y) f(x) ] ];

	public inline function get(p: IntPoint): T return this[p.y][p.x];
	public inline function set(p: IntPoint, value: T): T return this[p.y][p.x] = value;

	public function indexOf(e: T): Null<IntPoint> {
		for (y in 0...this.length) {
			var ye: Array<T> = this[y];
			var x: Int = ye.indexOf(e);
			if (x != -1) return new IntPoint(x, y);
		}
		return null;
	}

	#if (haxe_ver >= '4.0.0')
	extern public inline function keyValueIterator(): KeyValueIterator<Point<UInt>, T> {
		var x: UInt = 0;
		var y: UInt = 0;
		return {
			hasNext: () -> y < this.length && x < this[y].length,
			next: () -> {
				final r: {key:Point<UInt>, value:T} = {
					key: new Point(x, y),
					value: this[y++][x]
				}
				if (y >= this.length) {
					y = 0;
					x++;
				}
				r;
			}
		}
	}
	#end

	public static function create<T>(x: Int, y: Int, v: T): Matrix<T> return [ for (_ in 0...y) [ for (_ in 0...x) v ] ];

	//todo: ver, rotate, math op

}