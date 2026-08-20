package pony;

using Lambda;
using pony.Tools;

/**
 * Dictionary
 * @author AxGord
 */
class Dictionary<K, V> {

	public var ks: Array<K>;
	public var vs: Array<V>;

	public var count(get, null): Int;

	public var maxDepth: Int;

	public inline function new(maxDepth: Int = 1) {
		this.maxDepth = maxDepth;
		clear();
	}

	public inline function getIndex(k: K): Int return ks.superIndexOf(k, maxDepth);

	public function set(k: K, v: V): Int {
		final i: Int = getIndex(k);
		if (i != -1) {
			vs[i] = v;
			return i;
		} else {
			ks.push(k);
			return vs.push(v);
		}
	}

	public function get(k: K): V {
		final i: Int = getIndex(k);
		if (i == -1)
			return null;
		else
			return vs[i];
	}

	public inline function exists(k: K): Bool return getIndex(k) != -1;

	public function remove(k: K): Bool {
		final i: Int = getIndex(k);
		if (i != -1) {
			removeIndex(i);
			return true;
		} else
			return false;
	}

	public inline function removeIndex(i: Int): Void {
		ks.splice(i, 1);
		vs.splice(i, 1);
	}

	public inline function clear(): Void {
		ks = [];
		vs = [];
	}

	public inline function iterator(): Iterator<V> return vs.iterator();

	public inline function keys(): Iterator<K> return ks.iterator();

	public function toString(): String {
		final a: Array<String> = [for (k in keys()) '$k: ${get(k)}'];
		return '[${a.join(', ')}]';
	}

	public function removeValue(v: V): Void {
		final i: Int = getValueIndex(v);
		if (i != -1) {
			ks.splice(i, 1);
			vs.splice(i, 1);
		}
	}

	public function getKey(v: V): K {
		final i: Int = getValueIndex(v);
		if (i == -1) return null;
		return ks[i];
	}

	public inline function getValueIndex(v: V): Int return vs.indexOf(v);

	private inline function get_count(): Int return ks.length;

}
