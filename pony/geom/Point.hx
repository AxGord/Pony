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

typedef Point_<T> = { x:T, y:T }

/**
 * Point / IntPoint
 * @author AxGord
 */
abstract Point<T>(Point_<T>) from Point_<T> to Point_<T> {
	public var x(get, set):T;
	public var y(get, set):T;
	inline public function new(x:T, y:T) this = { x:x, y:y };
	inline private function get_x():T return this.x;
	inline private function get_y():T return this.y;
	inline private function set_x(v:T):T return this.x = v;
	inline private function set_y(v:T):T return this.y = v;
}

abstract IntPoint(Point_<Int>) to Point_<Int> from Point_<Int> {
	
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
}
