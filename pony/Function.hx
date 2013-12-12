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

import haxe.macro.Expr;
import haxe.macro.Context;
import pony.macro.Tools;
using Lambda;

#if cs
import dotnet.system.reflection.FieldInfo;
import cs.system.Type;
import cs.NativeArray;
import cs.internal.Function;
typedef CSHash = {
	o:Dynamic,
	n:String
}
#end

/**
 * Any function type!
 * @author AxGord
 */

abstract Function( { f:Dynamic, count:Int, args:Array<Dynamic>, id:Int, used:Int } ) {
	
	public static var unusedCount:Int;
	#if cs
	public static var cslist:Dictionary<CSHash, Function>;
	public static var list:Dictionary<CSHash, Function>;
	#else
	public static var list:Dictionary<Dynamic, Function>;
	#end
	private static var counter:Int;
	
	private static var searchFree:Bool;
	
	#if !cs
	public var id(get, never):Int;
	public var count(get, never):Int;
	public var used(get, never):Int;
	#end
	
	private static function __init__():Void {
		unusedCount = 0;
		#if cs
		cslist = new Dictionary<CSHash, Function>(1);
		list = new Dictionary<CSHash, Function>(1);
		#else
		list = new Dictionary<Dynamic, Function>(1);
		#end
		counter = -1;
		searchFree = false;
	}
	
	function new(f:Dynamic, count:Int, ?args:Array<Dynamic>) {
		counter++;
		if (searchFree) {//if counter make loop, then need search free id
			while (true) {
				for (e in list) {
					if (e.get_id() != counter)
						break;
				}
				counter++;
			}
		} else if (counter == -1)
			searchFree = true;
        this = { f:f, count:count, args:args == null?[]:args, id: counter, used: 0 };
	}
	
	static public function from(f:Dynamic, argc:Int):Function {
		#if cs
		var h:CSHash = buildCSHash(f);
		if (cslist.exists(h))
			return cslist.get(h);
		else {
			unusedCount++;
			var o:Function = new Function(f, argc);
			cslist.set(h, o);
			return o;
		}
		#else
		if (list.exists(f))
			return list.get(f);
		else {
			unusedCount++;
			var o:Function = new Function(f, argc);
			list.set(f, o);
			return o;
		}
		#end
	}
	
	#if cs
	private static function buildCSHash(f:Dynamic):CSHash {
		if (Std.is(f, Closure)) {
			return {o:untyped f.obj, n:untyped f.field};
		} else {
			var key:String = Std.string(f);
			var t:Type = untyped f.GetType();
			var a:NativeArray<FieldInfo> = untyped __cs__('t.GetFields()');
			var data:Array<Dynamic> = [];
			for (i in 0...a.Length) {
				data.push(Reflect.field(f, a[i].Name));
			}
			return {o:data, n:key};
		}
	}
	#end
	
    @:from static public inline function from0<R>(f:Void->R)
        return from(f,0);
	
    @:from static public inline function from1<R>(f:Dynamic->R)
        return from(f, 1);
	
    @:from static public inline function from2<R>(f:Dynamic->Dynamic->R)
        return from(f,2);
	
    @:from static public inline function from3<R>(f:Dynamic->Dynamic->Dynamic->R)
        return from(f,3);
	
    @:from static public inline function from4<R>(f:Dynamic->Dynamic->Dynamic->Dynamic->R)
        return from(f,4);
	
    @:from static public inline function from5<R>(f:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->R)
        return from(f,5);
	
    @:from static public inline function from6<R>(f:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->R)
        return from(f, 6);
		
    @:from static public inline function from7<R>(f:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->R)
        return from(f, 7);
		
	public inline function call(?args:Array<Dynamic>):Dynamic {
		if (args == null) args = [];
		return Reflect.callMethod(null, this.f, this.args.concat(args));
	}
	
	public inline function get_id():Int return this.id;
	public inline function get_count():Int return this.count;
	
	public inline function _setArgs(args:Array<Dynamic>):Void {
		this.count -= args.length;
		this.args = this.args.concat(args);
	}
	
	public inline function _use():Void this.used++;
	
	inline public function unuse():Void {
		this.used--;
		if (this.used <= 0) {
			#if cs
			if (Std.is(this.f, Closure))
				cslist.remove( buildCSHash(this.f) );
			else
				list.remove( buildCSHash(this.f) );
			#else
			list.remove(this.f);
			#end
			this = null;
			unusedCount--;
		}
	}
	
	public inline function get_used():Int return this.used;
}

/* Not supported on haxe later 3.01
class FunctionExtends {
	macro public static function call(f:ExprOf<Function>, a:Array < Expr > ):Expr
		return Tools.argsArrayAbstr(f, '_call', a);
	macro public static function bind(f:ExprOf<Function>, a:Array < Expr > ):Expr
		return Tools.argsArrayAbstr(f, '_bind', a);
	macro public static function setArgs(f:ExprOf<Function>, a:Array < Expr > ):Expr
		return Tools.argsArrayAbstr(f,'_setArgs',a);
}*/