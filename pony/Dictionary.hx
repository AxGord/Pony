/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony;

using Lambda;
using pony.Tools;
/**
 * Dictionary
 * @author AxGord
 */

class Dictionary<K, V>
{
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