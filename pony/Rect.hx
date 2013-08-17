/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pony.Point;
/**
 * ...
 * @author AxGord
 */
typedef Rect<T> = { x:T, y:T, width:T, height:T }

abstract IntRect(Rect<Int>) to Rect<Int> from Rect<Int> {
	
	@:op(A + B) inline static public function add1(lhs:IntRect, rhs:Point<Int>):IntRect
		return { x:lhs.getX() + rhs.x, y:lhs.getY() + rhs.y, width: lhs.getWidth(), height: lhs.getHeight() };
	
	@:op(A + B) inline static public function add2(lhs:IntRect, rhs:IntPoint):IntRect 
		return { x:lhs.getX() + rhs.getX(), y:lhs.getY() + rhs.getY(), width: lhs.getWidth(), height: lhs.getHeight() };
		
	@:op(A - B) inline static public function m1(lhs:IntRect, rhs:Point<Int>):IntRect
		return { x:lhs.getX() - rhs.x, y:lhs.getY() - rhs.y, width: lhs.getWidth(), height: lhs.getHeight() };
	
	@:op(A - B) inline static public function m2(lhs:IntRect, rhs:IntPoint):IntRect 
		return { x:lhs.getX() - rhs.getX(), y:lhs.getY() - rhs.getY(), width: lhs.getWidth(), height: lhs.getHeight() };
	
	public inline function getX():Int return this.x;
	public inline function getY():Int return this.y;
	
	public inline function getWidth():Int return this.width;
	public inline function getHeight():Int return this.height;
}