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
package pony.math;

import pony.magic.Declarator;
import pony.time.DeltaTime;

/**
 * Liker
 * @author AxGord <axgord@gmail.com>
 */
class Liker implements Declarator {

	@:arg private var base:Array<Array<Float>>;
	@:arg public var min:Float = 1;
	@:arg public var max:Float = 1;
	
	public function like(data:Array<Float>):Int {
		var id:Int = -1;
		var k:Float = 0;
		for (i in 0...base.length) {
			var r:Float = likek(base[i], data);
			if (r > k) {
				id = i;
				k = r;
			}
		}
		return id;
	}
	
	public function likeAsync(data:Array<Float>, ok:Int->Void, ?error:Dynamic->Void):Void {
		var id:Int = -1;
		var k:Float = 0;
		var i:Int = 0;
		var f:Void->Void = null;
		f = function() {
			try {
				var r:Float = likek(base[i], data);
				if (r > k) {
					id = i;
					k = r;
				}
				i++;
			} catch (e:Dynamic) {
				if (error == null) throw e;
				else error(e);
			}
			if (i >= base.length) {
				ok(id);
				DeltaTime.fixedUpdate.remove(f);
			}
		};
		DeltaTime.fixedUpdate.add(f);
	}
	
	public function likek(base:Array<Float>, data:Array<Float>):Float {
		if (base.length != data.length) throw 'data != base data';
		var k:Float = 0;
		for (i in 0...data.length) {
			var a = data[i];
			var b = base[i];
			if (a == b) {
				k += 1;
			} else if (a > b) {
				var r = a - b;
				if (r < max)
					k += 1 - r / max;
				else
					return 0;
			} else if (a < b) {
				var r = b - a;
				if (r < min)
					k += 1 - r / min;
				else
					return 0;
			}
		}
		return k;
	}
	
}