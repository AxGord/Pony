/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
 * Borders
 * @author AxGord <axgord@gmail.com>
 */
abstract Border<T:Float>({top:T, left:T, right:T, bottom:T}) {
	
	public var top(get, never):T;
	public var left(get, never):T;
	public var right(get, never):T;
	public var bottom(get, never):T;

	@:extern inline public function new(top:T, ?left:Null<T>, ?right:Null<T>, ?bottom:Null<T>) {
		if (left == null) left = top;
		if (right == null) right = left;
		if (bottom == null) bottom = top;
		this = {top:top, left:left, right:right, bottom:bottom};
	}
	
	@:from @:extern inline private static function fromNumber<T:Float>(v:T):Border<T> return new Border(v);
	
	@:extern inline private function get_top():T return this.top;
	@:extern inline private function get_left():T return this.left;
	@:extern inline private function get_right():T return this.right;
	@:extern inline private function get_bottom():T return this.bottom;
	
	@:from public static function fromString(v:String):Border<Float> {
		if (v == null || v == '') return new Border<Float>(0);
		var v = v.split(' ');
		return fromArray([Std.parseFloat(v[0]), Std.parseFloat(v[1]), Std.parseFloat(v[2]), Std.parseFloat(v[3])]);
	}
	
	@:from public static function fromArray<T:Float>(v:Array<T>):Border<T> {
		return switch v.length {
			case 0: cast new Border(0);
			case 1: new Border(v[0]);
			case 2: new Border(v[0], v[1]);
			case 3: new Border(v[0], v[1], v[2]);
			case 4: new Border(v[0], v[1], v[2], v[3]);
			case _: throw 'Uncorrect array length';
		}
	}
	
	@:op(A * B) @:extern inline public function mul(rhs:Float):Border<Float>
		return new Border(top * rhs, left * rhs, right * rhs, bottom * rhs);
	
}