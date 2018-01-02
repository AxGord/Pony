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
package pony.math;

/**
 * Balance
 * 1% = 0.01
 * @author AxGord <axgord@gmail.com>
 */
abstract Balance(Array<Float>) from Array<Float> {
	
    @:arrayAccess public inline function arrayAccess(key:Int):Float {
        return this[key];
    }
    
    @:arrayAccess public function arrayWrite<T>(key:Int, value:Float):Float {
		if (value > 1) throw 'value can\'t be > 1';
		else if (value == 1) {
			for (i in 0...this.length) if (key != i) this[i] = 0;
			this[key] = value;
		} else {
			var c:Float = value - this[key];
			var na:Array<Float> = [];
			for (i in 0...this.length) {
				if (i == key) {
					na.push(value);
					continue;
				}
				var a:Float = this[i];
				var b:Float = getSum(i, key);
				var x:Float = c * (1 - (1 / (a / b + 1)));
				na.push(this[i] - x);
			}
			for (i in 0...na.length) this[i] = na[i];
		}
		return value;
    }
	
	private function getSum(a:Int, b:Int):Float {
		var sum:Float = 0;
		for (i in 0...this.length)
			if (i != a && i != b)
				sum += this[i];
		return sum;
	}
	
	public function calc(n:Int):Void {
		var s:Float = 1;
		for (i in 0...this.length) if (i != n) s -= this[i];
		this[n] = s;
	}
	
	public inline function iterator():Iterator<Float> return this.iterator();
	
}