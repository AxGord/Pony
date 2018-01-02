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
package pony.color;

/**
 * Color, can be negative
 * @author AxGord <axgord@gmail.com>
 */
abstract Color({a:Int, r:Int, g:Int, b:Int}) {
	/**
	 * ARGB
	 */
	public var argb(get, never):UInt;
	/**
	 * RGB
	 */
	public var rgb(get,never):UInt;
	/**
	 * Alpha 0...255
	 */
	public var a(get, never):Int;
	/**
	 * Red 0...255
	 */
	public var r(get, never):Int;
	/**
	 * Green 0...255
	 */
	public var g(get, never):Int;
	/**
	 * Blue 0...255
	 */
	public var b(get, never):Int;
	/**
	 * Power
	 */
	public var power(get, never):Int;
	/**
	 * Alpha 0...1
	 */
	public var af(get, never):Float;
	/**
	 * Red 0...1
	 */
	public var rf(get, never):Float;
	/**
	 * Green 0...1
	 */
	public var gf(get, never):Float;
	/**
	 * Blue 0...1
	 */
	public var bf(get,never):Float;
	/**
	 * This color with inverted alpha
	 */
	public var invertAlpha(get, never):Color;
	/**
	 * Inverted color
	 */
	public var invert(get, never):Color;
	/**
	 * Construct from ARGB values
	 */
	inline public function new(a:Int, r:Int, g:Int, b:Int) this = {a:a, r:r, g:g, b:b};
	/**
	 * Build from RGB values
	 */
	inline public static function fromRGB(r:Int, g:Int, b:Int):Color return new Color(0, r, g, b);
	/**
	 * Build from ARGB values
	 */
	inline public static function fromARGB(a:Int, r:Int, g:Int, b:Int):Color return new Color(a, r, g, b);
	/**
	 * Safely building from RGB values
	 * Values limited -255...255
	 */
	public static function fromRGBSave(r:Int, g:Int, b:Int):Color {
		r = lim(r);
		g = lim(g);
		b = lim(b);
		return fromRGB(r, g, b);
	}
	/**
	 * Safely building from ARGB values
	 */
	public static function fromARGBSave(a:Int, r:Int, g:Int, b:Int):Color {
		a = lim(a);
		r = lim(r);
		g = lim(g);
		b = lim(b);
		return fromARGB(a, r, g, b);
	}
	
	inline static private function lim(v:Int):Int {
		if (v > 0xFF) v = 0xFF;
		if (v < -0xFF) v = 0xFF;
		return v;
	}
	
	inline private function _invert(v:Int):Int return 0xFF - v;
	
	inline private function get_invertAlpha():Color return fromARGBSave(_invert(a), r, g, b);
	inline private function get_invert():Color return fromARGBSave(a, _invert(r), _invert(g), _invert(b));
	
	@:from inline static private function fromUInt(v:UInt):Color return fromUColor(new UColor(v));
	
	@:from inline static private function fromUColor(v:UColor):Color return new Color(Std.int(v.a), Std.int(v.r), Std.int(v.g), Std.int(v.b));
	@:to inline public function toUColor():UColor return UColor.fromARGBSave(a, r, g, b);
	
	@:to inline private function get_argb():UInt return toUColor();
	inline private function get_rgb():UInt return toUColor().rgb;
	
	inline private function get_power():Int return r + g + b;
	
	inline private function get_a():Int return this.a;
	inline private function get_r():Int return this.r;
	inline private function get_g():Int return this.g;
	inline private function get_b():Int return this.b;
	
	inline private function get_af():Float return a / 255;
	inline private function get_rf():Float return r / 255;
	inline private function get_gf():Float return g / 255;
	inline private function get_bf():Float return b / 255;
	/**
	 * Convert color to string
	 */
	@:to inline public function toString():String return toUColor();
	/**
	 * Build color from string
	 */
	@:from inline public static function fromString(s:String):Color return UColor.fromString(s);
	/**
	 * First color subtract second color
	 */
	@:op(A - B) inline static public function sub(a:Color, b:Color):Color return fromARGBSave(a.a - b.a, a.r - b.r, a.g - b.g, a.b - b.b);
	/**
	 * Colors sum
	 */
	@:op(A + B) inline static public function add(a:Color, b:Color):Color return fromARGBSave(a.a + b.a, a.r + b.r, a.g + b.g, a.b + b.b);
	//@:op(A + B) inline static public function add1(a:UColor, b:Color):Color return UColor.fromARGBSave(a.a + b.a, a.r + b.r, a.g + b.g, a.b + b.b);
	//@:op(A + B) inline static public function add2(a:Color, b:UColor):Color return UColor.fromARGBSave(a.a + b.a, a.r + b.r, a.g + b.g, a.b + b.b);
	/**
	 * Apply bright to this color
	 */
	inline public function bright(v:Int):Color return fromARGBSave(a, r + v, g + v, b + v);
}