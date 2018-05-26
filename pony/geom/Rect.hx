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

import pony.geom.Point;

/**
 * Rect / IntRect
 * @author AxGord
 */
typedef SimpleRect<T> = { x:T, y:T, width:T, height:T }

abstract Rect<T>(SimpleRect<T>) to SimpleRect<T> from SimpleRect<T>  {
	
	public var x(get, set):T;
	public var y(get, set):T;
	public var width(get, set):T;
	public var height(get, set):T;

	public inline function new(x:T, y:T, width:T, height:T) {
		this = {x: x, y: y, width: width, height: height};
	}

	private inline function get_x():T return this.x;
	private inline function get_y():T return this.y;
	private inline function get_width():T return this.width;
	private inline function get_height():T return this.height;

	private inline function set_x(v:T):T return this.x = v;
	private inline function set_y(v:T):T return this.y = v;
	private inline function set_width(v:T):T return this.width = v;
	private inline function set_height(v:T):T return this.height = v;
}

abstract IntRect(SimpleRect<Int>) to SimpleRect<Int> from SimpleRect<Int> {
	
	public var x(get, never):Int;
	public var y(get, never):Int;
	public var width(get, never):Int;
	public var height(get, never):Int;
	
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
	
	private inline function get_x():Int return this.x;
	private inline function get_y():Int return this.y;
	private inline function get_width():Int return this.width;
	private inline function get_height():Int return this.height;
}