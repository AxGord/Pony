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
package pony.flash;

import haxe.Log;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.PosInfos;

#if !macro
import flash.external.ExternalInterface;
import pony.events.Signal2;
#end

/**
 * Interface for ExternalInterface
 * @author AxGord
 */
class Exterface implements Dynamic<Exterface> implements pony.magic.HasSignal {
	
	public var name(default, null):String;
	
	#if !macro
	@:auto public var signal:Signal2<Dynamic, Dynamic>;
	public static var get:Exterface = new Exterface();
	private static var map:Map<String, Exterface> = new Map<String, Exterface>();
	
	private function new(?name:String) {
		if (name != null) {
			this.name = name;
			#if debug
			trace('Add callback: $name');
			#else
			ExternalInterface.addCallback(name, Reflect.makeVarArgs(dispatchArgs));
			#end
			map.set(name, this);
		}
	}
	
	private function dispatchArgs(a:Array<Dynamic>):Void eSignal.dispatch(a[0], a[1]);
	
	public static function regLog():Void {
		#if !debug
		Log.trace = function(m:Dynamic, ?p:PosInfos):Void get.log.call(p.fileName+':' + p.lineNumber + ': ' + m);
		#end
	}
	
	public function resolve(field:String):Exterface {
		var s:String = (name != null ? name + '.' : '') + field;
		return map.exists(s) ? map.get(s) : new Exterface(s);
	}
	
	public function callEmpty():Void {
		#if !debug
		ExternalInterface.call(name);
		#else
		trace('Call $name');
		#end
	}
	
	#end
	
	
	macro public function call(ethis : Expr, args:Array<Expr>):Expr {
		#if debug
		//var arr:Array<Expr> = [Context.makeExpr(args, Context.currentPos())];
		//var ae:Expr = Context.makeExpr(arr, Context.currentPos());
		//trace(ethis);
		return { expr: ECall({expr:EField(ethis,'_trace'), pos:Context.currentPos()}, [Context.makeExpr(args.length, Context.currentPos())]), pos: Context.currentPos()};
		#else
		args.unshift(macro $ethis.name);
		return macro flash.external.ExternalInterface.call($a { args } );
		#end
	}
	
	#if debug
	public function _trace(t:Dynamic):Dynamic {
		trace('Call $name: $t');
		return null;
	}
	#end
	
}