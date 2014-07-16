/**
* Copyright (c) 2013-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.geom;

/**
 * Angle
 * @author AxGord <axgord@gmail.com>
 */
abstract Angle(Float) to Float {

	public var percent(get,never):Float;
	
	inline public function new(v) this = v;
	
	@:from inline static private function fromFloat(v:Float):Angle {
		v = v % 360;
		if (v < 0) v += 360;
		return new Angle(v);
	}
	
	@:from inline static private function fromInt(v:Int):Angle return fromFloat(v);
	
	inline private function get_percent():Float return this / 360;
	
	
	@:op(A + B) private static inline function add(a:Angle, b:Angle):Angle return (a:Float) + (b:Float);
	@:op(A / B) private static inline function div(a:Angle, b:Angle):Angle return (a:Float) / (b:Float);
	@:op(A * B) private static inline function mul(a:Angle, b:Angle):Angle return (a:Float) * (b:Float);
	@:op(A - B) private static inline function sub(a:Angle, b:Angle):Angle return (a:Float) - (b:Float);
	
	
	@:op(A > B) private static inline function gt(a:Angle, b:Angle):Bool return (a:Float) > (b:Float);
	@:op(A >= B) private static inline function gte(a:Angle, b:Angle):Bool return (a:Float) >= (b:Float);

	@:op(A < B) private static inline function lt(a:Angle, b:Angle):Bool return (a:Float) < (b:Float);
	@:op(A <= B) private static inline function lte(a:Angle, b:Angle):Bool return (a:Float) <= (b:Float);
	
	@:op(A % B) private static inline function mod(a:Angle, b:Angle):Angle return (a:Float) % (b:Float);
}