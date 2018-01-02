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
package pony.macro;
#if (macro || dox)
import haxe.macro.Context;
import haxe.macro.Expr;
/**
 * ...
 * @author AxGord
 */
class Tools {
	
	public static var staticPlatform:Bool = Context.defined('cs') || Context.defined('flash') || Context.defined('java');

	public inline static function argsArray(func:Expr, args:Array<Expr>):Expr {
		args.shift();
		return macro $e{func} ($a{[[$a{args}]]});
	}
	
	public static function argsArrayAbstr(obj:ExprOf<Function>, name:String, args:Array < Expr > ):Expr {
		return macro $e{macro $ { obj } .$name} ($a{[[$a{args}]]});
	}
	
	public static function getMeta(a:Metadata, n:String, addHidding:Bool=false):MetadataEntry {
		if (a == null) return null;
		for (e in a) if (e.name == n || (addHidding && e.name == ':'+n)) return e;
		return null;
	}
	
	public static function checkMeta(a:Metadata, an:Array<String>):Bool {
		for (n in an) if (getMeta(a, n) != null) return true;
		return false;
	}
	
	public static function createInit():Field {
		return {name: '__init__', access: [AStatic, APrivate], kind: FFun({args:[], ret: ComplexType.TPath({pack:[],name:'Void'}), expr: null}), pos: Context.currentPos()};
	}
	
	public static function createNew():Field {
		return {name: 'new', access: [APublic], kind: FFun({args:[], ret: ComplexType.TPath({pack:[],name:'Void'}), expr: null}), pos: Context.currentPos()};
	}
	
}
#end