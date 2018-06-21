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
package pony;

/**
 * Typed object pool
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 3.30)
@:generic class TypedPool<T:haxe.Constraints.Constructible<Dynamic>> implements IPool<T> {
#else
@:generic class TypedPool<T:{function new():Void;}> implements IPool<T> {
#end
	private var list:Array<T> = [];
	
	inline public function new() {}
	
	#if !flash
	@:extern inline
	#end
	public function get():T {
		var v = list.pop();
		return v == null ? new T() : v;
	}
	
	#if !flash
	@:extern inline
	#end
	public function ret(obj:T):Void list.push(untyped obj);
	
}

/**
 * Typed object pool with arg
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 3.30)
@:generic class TypedPool1<T:haxe.Constraints.Constructible<Dynamic>, A1> {
#else
@:generic class TypedPool1<T:{function new(a1:A1):Void;}, A1> {
#end
	private var list:Array<T> = [];
	
	inline public function new() {}
	
	#if !flash
	@:extern inline
	#end
	public function get(a1:A1):T {
		var v = list.pop();
		return v == null ? new T(a1) : v;
	}
	
	#if !flash
	@:extern inline
	#end
	public function ret(obj:T):Void list.push(untyped obj);
	
}