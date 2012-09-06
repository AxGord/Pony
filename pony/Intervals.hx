/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import pony.magic.Declarator;

/**
 * @example [[2...7, 9...15, 64]]
 * @author AxGord
 */

class Intervals implements Declarator
{
	@arg private var v:Dynamic;
	@arg private var d:Int = 1;
	
	private var loopit:Iterator<Int>;

	public function iterator():Iterator<Int> {
		if (Std.is(v, Int)) {
			var b:Bool = true;
			return {
				hasNext: function():Bool return b,
				next: function():Int {
					b = false;
					return Std.int(v * d);
				}
			};
		} else if (Std.is(v, IntIter)) {
			var it:IntIter = new IntIter(v.min, v.max);
			if (d == 1)
				return it;
			else
				return {
					hasNext: it.hasNext,
					next: function():Int return Std.int(it.next() * d)
				};
		} else if (Std.is(v, Array)) {
			var it:Iterator<Dynamic> = v.iterator();
			var sub:Iterator<Dynamic> = null;
			return {
				hasNext: function():Bool {
					return (sub != null && sub.hasNext()) || it.hasNext();
				},
				next: function():Int {
					if (sub != null && sub.hasNext())
						return sub.next();
					else {
						while (it.hasNext()) {
							var n:Dynamic = it.next();
							var iv:Intervals = Std.is(n, Intervals) ? n : new Intervals(n);
							sub = iv.iterator();
							if (sub.hasNext()) 
								return Std.int(sub.next() * d);
						}
						throw 'Nothing next';
					}
				}
			};
		} else throw 'Unknown type';
	}
	
	public function loop():Int {
		if (loopit == null)
			loopit = iterator();
		if (loopit.hasNext())
			return loopit.next();
		else {
			loopit = iterator();
			if (!loopit.hasNext()) throw 'Out';
			return loopit.next();
		}
	}
	
	public function resetLoop():Void {
		loopit = null;
	}
	
}