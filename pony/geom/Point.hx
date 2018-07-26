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
package pony.geom;

typedef Point_<T> = { x:T, y:T }

/**
 * Point / IntPoint
 * @author AxGord
 */
abstract Point<T:Float>(Point_<T>) from Point_<T> to Point_<T> to Point<Float> {
	public var x(get, set):T;
	public var y(get, set):T;
	inline public function new(x:T, y:T) this = { x:x, y:y };
	inline private function get_x():T return this.x;
	inline private function get_y():T return this.y;
	inline private function set_x(v:T):T return this.x = v;
	inline private function set_y(v:T):T return this.y = v;
	public function toString():String return '(${this.x}, ${this.y})';

	@:op(A * B) inline static public function mul2<T:Float>(lhs:Point<T>, rhs:Point<T>):Point<T>
		return { x:lhs.x * rhs.x, y:lhs.y * rhs.y };

	@:op(A * B) inline static public function mul1<T:Float>(lhs:Point<T>, rhs:T):Point<T>
		return { x:lhs.x * rhs, y:lhs.y * rhs };

	@:op(A + B) inline static public function add2<T:Float>(lhs:Point<T>, rhs:Point<T>):Point<T>
		return { x:lhs.x + rhs.x, y:lhs.y + rhs.y };

	@:op(A + B) inline static public function add1<T:Float>(lhs:Point<T>, rhs:T):Point<T>
		return { x:lhs.x + rhs, y:lhs.y + rhs };

	@:op(A - B) inline static public function sub2<T:Float>(lhs:Point<T>, rhs:Point<T>):Point<T>
		return { x:lhs.x - rhs.x, y:lhs.y - rhs.y };

	@:op(A - B) inline static public function sub1<T:Float>(lhs:Point<T>, rhs:T):Point<T>
		return { x:lhs.x - rhs, y:lhs.y - rhs };
}

abstract IntPoint(Point_ < Int > ) to Point_ < Int > from Point_ < Int > {
	
	public static var OneUp:IntPoint = new IntPoint(0, -1);
	public static var OneDown:IntPoint = new IntPoint(0, 1);
	public static var OneLeft:IntPoint = new IntPoint(-1, 0);
	public static var OneRight:IntPoint = new IntPoint(1, 0);
	
	public var x(get, never):Int;
	public var y(get, never):Int;
	
	public function new(x:Int, y:Int) this = {x:x, y:y};
	
	@:op(A + B) inline static public function add1(lhs:IntPoint, rhs:Point<Int>):IntPoint
		return { x:lhs.getX() + rhs.x, y:lhs.getY() + rhs.y };
		
	@:op(A + B) inline static public function add2(lhs:IntPoint, rhs:IntPoint):IntPoint
		return { x:lhs.getX() + rhs.getX(), y:lhs.getY() + rhs.getY() };
		
	@:op(A - B) inline static public function m1(lhs:IntPoint, rhs:Point<Int>):IntPoint
		return { x:lhs.getX() - rhs.x, y:lhs.getY() - rhs.y };
		
	@:op(A - B) inline static public function m2(lhs:IntPoint, rhs:IntPoint):IntPoint
		return { x:lhs.getX() - rhs.getX(), y:lhs.getY() - rhs.getY() };
		
	private inline function get_x():Int return this.x;
	private inline function get_y():Int return this.y;
	public inline function getX():Int return this.x;
	public inline function getY():Int return this.y;
	
	@:from static public inline function fromRect(r:Rect<Int>):IntPoint return { x: r.x, y: r.y };
	
	@:op(A == B) inline private function equal(b:IntPoint):Bool return x == b.x && y == b.y;
	
	@:from public static function fromDirection(d:Direction):IntPoint {
		return switch d {
			case Direction.up: OneUp;
			case Direction.down: OneDown;
			case Direction.left: OneLeft;
			case Direction.right: OneRight;
		}
	}

	public function toString():String return '(${this.x}, ${this.y})';
	
}
