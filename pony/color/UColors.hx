/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.color;
#if flash
import flash.Vector.Vector;
#end
using pony.math.MathTools;
using Std;
/**
 * Colors
 * @author AxGord <axgord@gmail.com>
 */
@:forward(push, pop, iterator)
abstract UColors(Array<UColor>) from Array<UColor> to Array<UColor> {
	/**
	 * Middle color
	 */
	public var mid(get, never):UColor;
	/**
	 * Middle color with inverted alpha
	 */
	public var midInvertAlpha(get, never):UColor;
	
	inline private function get_mid():UColor return _mid(0);
	inline private function get_midInvertAlpha():UColor return _mid(0xFF);
	
	private function _mid(alp:UInt):UColor {
		var r:Array<UInt> = [];
		var g:Array<UInt> = [];
		var b:Array<UInt> = [];
		for (e in this) if (e.a == alp) {
			r.push(e.r);
			g.push(e.g);
			b.push(e.b);
		}
		return Color.fromRGB(r.arithmeticMean().int(), g.arithmeticMean().int(), b.arithmeticMean().int());
	}
	/**
	 * Build from iterable colors
	 */
	@:from inline public static function fromIterable(it:Iterable<UColor>):UColors return Lambda.array(it);
	/**
	 * Build from iterable UInt
	 */
	@:from inline public static function fromIterableUInt(it:Iterable<UInt>):UColors return Lambda.array(it);
	#if (flash && !doc_gen)
	@:from inline public static function fromVector(a:flash.Vector<UInt>):UColors return [for(i in 0...a.length) a[i]];
	#end
}