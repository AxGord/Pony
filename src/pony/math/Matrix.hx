package pony.math;

import pony.geom.Point;

/**
 * Matrix
 * @author AxGord <axgord@gmail.com>
 */
@:forward(push, pop, length) @:nullSafety(Strict)
abstract Matrix<T>(Array<Array<T>>) from Array<Array<T>> to Array<Array<T>> {

	public function cut(x: Int, y: Int): Matrix<T> return [ for (i in 0...x) [ for (j in 0...y) this[i][j] ] ];

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
	public function map<B>(f: T -> B): Matrix<B> return [ for (x in this) [ for (y in x) f(y) ] ];

	public inline function get(p: Point<Int>): T return this[p.x][p.y];
	public inline function set(p: Point<Int>, value: T): T return this[p.x][p.y] = value;

	public function indexOf(e: T): Null<Point<Int>> {
		for (x in 0...this.length) {
			var xe: Array<T> = this[x];
			var y: Int = xe.indexOf(e);
			if (y != -1) return new Point<Int>(x, y);
		}
		return null;
	}

	public function setAll(value: T): Void for (x in 0...this.length) for (y in 0...this[x].length) this[x][y] = value;

	public function iterator(): Iterator<T> {
		var x: UInt = 0;
		var y: UInt = 0;
		return {
			hasNext: () -> x < this.length && y < this[x].length,
			next: () -> {
				var r: T = this[x++][y];
				if (x >= this.length) {
					x = 0;
					y++;
				}
				r;
			}
		}
	}

	#if (haxe_ver >= '4.0.0')
	extern public inline function keyValueIterator(): KeyValueIterator<Point<UInt>, T> {
		var x: UInt = 0;
		var y: UInt = 0;
		return {
			hasNext: () -> x < this.length && y < this[x].length,
			next: () -> {
				final r: { key: Point<UInt>, value: T } = {
					key: new Point(x, y),
					value: this[x++][y]
				}
				if (x >= this.length) {
					x = 0;
					y++;
				}
				r;
			}
		}
	}
	#end

	public static function create<T>(x: Int, y: Int, v: T): Matrix<T> return [ for (_ in 0...x) [ for (_ in 0...y) v ] ];

	//todo: ver, rotate, math op

}