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
package pony.color;
/**
 * UColor
 * Can be only positive
 * @author AxGord <axgord@gmail.com>
 */
abstract UColor(UInt) from UInt to UInt {

	/**
	 * ARGB
	 */
	public var argb(get,never):UInt;
	/**
	 * RGB
	 */
	public var rgb(get,never):UInt;
	
	/**
	 * Alpha 0...255
	 */
	public var a(get,never):UInt;
	/**
	 * Red 0...255
	 */
	public var r(get,never):UInt;
	/**
	 * Green 0...255
	 */
	public var g(get,never):UInt;
	/**
	 * Blue 0...255
	 */
	public var b(get, never):UInt;
	
	/**
	 * Power
	 */
	public var power(get, never):UInt;
	
	/**
	 * Alpha 0...1
	 */
	public var af(get,never):Float;
	/**
	 * Red 0...1
	 */
	public var rf(get,never):Float;
	/**
	 * Green 0...1
	 */
	public var gf(get,never):Float;
	/**
	 * Blue 0...1
	 */
	public var bf(get,never):Float;
	
	/**
	 * This color with inverted alpha
	 */
	public var invertAlpha(get, never):UColor;
	/**
	 * Inverted color
	 */
	public var invert(get, never):UColor;
	
	/**
	 * Construct from ARGB values
	 */
	inline public function new(v:UInt) this = v;
	/**
	 * Build from RGB values
	 */
	inline public static function fromRGB(r:UInt, g:UInt, b:UInt):UColor return (r << 16) + (g << 8) + b;
	/**
	 * Build from ARGB values
	 */
	inline public static function fromARGB(a:UInt, r:UInt, g:UInt, b:UInt):UColor return (a << 24) + (r << 16) + (g << 8) + b;
	/**
	 * Safely building from RGB values
	 * Values limited 0...255
	 */
	public static function fromRGBSave(r:Int, g:Int, b:Int):UColor {
		r = lim(r);
		g = lim(g);
		b = lim(b);
		return fromRGB(r, g, b);
	}
	/**
	 * Safely building from ARGB values
	 */
	public static function fromARGBSave(a:Int, r:Int, g:Int, b:Int):UColor {
		a = lim(a);
		r = lim(r);
		g = lim(g);
		b = lim(b);
		return fromARGB(a, r, g, b);
	}
	
	inline static private function lim(v:Int):UInt {
		if (v > 0xFF) v = 0xFF;
		if (v < 0x00) v = 0x00;
		return v;
	}
	
	inline private function _invert(v:UInt):UInt return 0xFF - v;
	
	inline private function get_invertAlpha():UColor return fromARGB(_invert(a), r, g, b);
	inline private function get_invert():UColor return fromARGB(a, _invert(r), _invert(g), _invert(b));
	
	inline private function get_argb():UInt return this;
	inline private function get_rgb():UInt return this & 0xFFFFFF;
	
	inline private function get_power():UInt return r + g + b;
	
	inline private function get_a():UInt return (this >> 24) & 255;
	inline private function get_r():UInt return (this >> 16) & 255;
	inline private function get_g():UInt return (this >> 8) & 255;
	inline private function get_b():UInt return this & 255;
	/*#if cs
	private function get_af():Float return a / 255;
	private function get_rf():Float return r / 255;
	private function get_gf():Float return g / 255;
	private function get_bf():Float return b / 255;
	#else*/
	inline private function get_af():Float return a / 255;
	inline private function get_rf():Float return r / 255;
	inline private function get_gf():Float return g / 255;
	inline private function get_bf():Float return b / 255;
	//#end
	
	//Haxe fail!
	/*
	@:op(A + B) inline static private function addToString(a:String, b:UColor):UColor return a+b.toString();
	@:op(A + B) inline static private function addToString2(a:UColor, b:String):UColor return a.toString()+b;
	*/
	/**
	 * First color subtract second color
	 */
	@:op(A - B) inline static private function sub(a:UColor, b:UColor):Color return Color.sub(a, b);
	/**
	 * Colors sum
	 */
	@:op(A + B) inline static private function add(a:UColor, b:UColor):UColor return fromARGB(a.a + b.a, a.r + b.r, a.g + b.g, a.b + b.b);
	
	#if (HUGS && !WITHOUTUNITY)
	@:to inline public function toUnity():unityengine.Color {
		return new unityengine.Color(rf, gf, bf, 1-af);
	}
	#end
	
	@:op(A > B) private static inline function gt(a:UColor, b:UColor):Bool return a.power > b.power;
	@:op(A >= B) private static inline function gte(a:UColor, b:UColor):Bool return a.power >= b.power;
	@:op(A < B) private static inline function lt(a:UColor, b:UColor):Bool return a.power < b.power;
	@:op(A <= B) private static inline function lte(a:UColor, b:UColor):Bool return a.power <= b.power;

	/**
	 * Convert color to string
	 */
	@:to inline public function toString():String return '#' + StringTools.hex(this);
	/**
	 * Build color from string
	 */
	@:from public static function fromString(s:String):UColor {
		s = StringTools.trim(s);
		return new UColor(
			if (s.substr(0, 1) == '#') Std.parseInt('0x' + s.substr(1))
			else if (s.substr(0, 3) == 'rgb') {
				s = StringTools.ltrim(s.substr(3));
				if (StringTools.startsWith(s, '(') && StringTools.endsWith(s, ')')) {
					var d = s.substr(1, s.length - 2).split(',').map(Std.parseInt);
					if (d.length != 3) throw 'Color params error';
					fromRGB(d[0],d[1],d[2]);
				} else throw 'Color syntax error';
			}
			else if (s.substr(0, 4) == 'argb') {
				s = StringTools.ltrim(s.substr(4));
				if (StringTools.startsWith(s, '(') && StringTools.endsWith(s, ')')) {
					var d = s.substr(1, s.length - 2).split(',').map(Std.parseInt);
					if (d.length != 4) throw 'Color params error';
					fromARGB(d[0],d[1],d[2],d[3]);
				} else throw 'Color syntax error';
			}
			else switch s {
				case 'red': 0xFF0000;
				case 'green': 0x00FF00;
				case 'blue': 0x0000FF;
				case _: throw 'Unknown color';
			}
		);
	}
	
}