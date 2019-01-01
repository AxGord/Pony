package pony;

using Lambda;
using pony.Tools;

/**
 * Dictionary
 * @author AxGord
 */
class Dictionary<K, V> {
	
	public var ks:Array<K>;
	public var vs:Array<V>;
	
	public var count(get, null):Int;
	
	public var maxDepth:Int;
	
	inline public function new(maxDepth:Int = 1) {
		this.maxDepth = maxDepth;
		clear();
	}

	inline public function getIndex(k:K):Int return ks.superIndexOf(k, maxDepth);
	
	public function set(k:K, v:V):Int {
		var i:Int = getIndex(k);
		if (i != -1) {
			vs[i] = v;
			return i;
		} else {
			ks.push(k);
			return vs.push(v);
		}
	}
	
	public function get(k:K):V {
		var i:Int = getIndex(k);
		if (i == -1)
			return null;
		else
			return vs[i];
	}
	
	inline public function exists(k:K):Bool return getIndex(k) != -1;
	
	public function remove(k:K):Bool {
		var i:Int = getIndex(k);
		if (i != -1) {
			removeIndex(i);
			return true;
		} else
			return false;
	}
	
	inline public function removeIndex(i:Int):Void {
		ks.splice(i, 1);
		vs.splice(i, 1);
	}
	
	inline public function clear():Void {
		ks = [];
		vs = [];
	}
	
	inline public function iterator():Iterator<V> return vs.iterator();
	
	inline public function keys():Iterator<K> return ks.iterator();
	
	public function toString():String {
		var a:Array<String> = [];
		for (k in keys()) {
			a.push(k + ': ' + get(k));
		}
		return '[' + a.join(', ') + ']';
	}
	
	public function removeValue(v:V):Void {
		var i:Int = getValueIndex(v);
		if (i != -1) {
			ks.splice(i, 1);
			vs.splice(i, 1);
		}
	}
	
	public function getKey(v:V):K {
		var i:Int = getValueIndex(v);
		if (i == -1) return null;
		return ks[i];
	}
	
	inline public function getValueIndex(v:V):Int return vs.indexOf(v);
	
	inline private function get_count():Int return ks.length;
	
}