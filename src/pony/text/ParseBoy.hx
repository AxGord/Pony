package pony.text;

import pony.magic.Declarator;
import pony.math.MathTools;

typedef PosLen = {
	pos: Int, len: Int
}

/**
 * All for good parse.
 * @author AxGord <axgord@gmail.com>
 */
class ParseBoy<T> implements Declarator {

	@:arg public var t: String;
	@:arg public var space: Bool = true;

	/**
	 * Current position.
	 */
	public var pos: Int = 0;

	/**
	 * Position before call 'goto' function.
	 */
	public var beforeGoto: Int;

	/**
	 * Count symbols skiped 'goto' function.
	 */
	public var lengthGoto: Int;

	/**
	 * Result data. Use functions:  push, pop, beginContent, endContent.
	 */
	public var data: Array<T> = [];
	private var stack: Array<Array<T>> = [];

	/**
	 * Can igonre spaces.
	 * @param v - search string.
	 * @return begin position and searched string length.
	 * @see indexOf
	 */
	public function indexOf(v: String): PosLen {
		if (space) {
			var n: Int = 0, i: Int = pos, lc: Int = 0;
			while (i < t.length) {
				var c: String = t.charAt(i);
				if (c == v.charAt(n)) {
					if (n >= v.length - 1) {
						lc++;
						return { pos: i - lc + 1, len: lc };
					} else {
						n++;
						lc++;
					}
				} else if (c != ' ') {
					i -= n;
					lc = n = 0;
				} else if (n != 0)
					lc++;
				i++;
			}
			return null;
		} else
			return {pos: t.indexOf(v, pos), len: v.length};
	}

	/**
	 * Go to string.
	 * @param	a searched strings.
	 * @param nospace if true return -2 if no space.
	 * @return string number, -1 if not.
	 */
	public function gt(a: Array<String>, nospace: Bool = false): Int {
		beforeGoto = pos;
		var r:Int = -1;
		var ipos:Int = MathTools.maxInt;

		if (nospace) {
			for (i in pos...t.length) {
				if (t.charAt(i) != ' ') {
					r = -2;
					ipos = i;
					lengthGoto = 0;
					break;
				}
			}
		}

		for (n in 0...a.length) {
			if (a[n] == null) continue;
			var io: PosLen = indexOf(a[n]);
			if (io != null)
				if (io.pos <= ipos) {
					r = n;
					ipos = io.pos;
					lengthGoto = io.len;
				}
		}
		if (r != -1) {
			pos = ipos + lengthGoto;
		} else {
			pos = MathTools.maxInt;
			lengthGoto = 0;
		}
		return r;
	}

	public inline function str(): String {
		return t.substr(beforeGoto, pos - beforeGoto - lengthGoto);
	}

	public function skipSpace(): Void {
		if (space)
			while (pos < t.length && t.charAt(pos) == ' ') pos++;
	}

	public function beginContent(): Void {
		stack.push(data);
		data = [];
	}

	public inline function endContent(): Void {
		data = stack.pop();
	}

	public inline function push(v: T): Int {
		return data.push(v);
	}

	public inline function pop(): T {
		return data.pop();
	}

	//Next only for T == String

	public inline function pushStr(): Int {
		return push(cast str());
	}

	public function gotoPushStr(search:String): Int {
		return if (gt([search]) != -1)
			pushStr();
		else {
			pos = beforeGoto;
			push(null);
		}
	}

	public inline function pushEnd(): Int {
		return push(cast t.substr(pos));
	}

}