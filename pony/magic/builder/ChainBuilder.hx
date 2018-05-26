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
package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
#end

/**
 * ChainBuilder
 * @author AxGord <axgord@gmail.com>
 */
class ChainBuilder {
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var ch = (Type.getClassName(Chain));
		var cl:String = null;
		for (i in Context.getLocalClass().get().interfaces) {
			if (i.t.toString() == ch) {
				cl = i.params[0].getParameters()[0].toString();
				break;
			}
		}
		if (cl == null) throw "Can't find type T (Chain<T>)";
		#if display
		try {
		#end
		var a = cl.split('.');
		var name = a.pop();
		
		fields.push( {
			pos: Context.currentPos(),
			name: 'list',
			meta: [],
			doc: null,
			access: [APublic],
			kind: FVar(TPath({name: 'Array', pack:[], params:[TPType(TPath({name: name, pack:a, params:[]}))]}))
		});
		
		var exprs:Array<Expr> = [Context.parse('list = new Array<$cl>()', Context.currentPos())];
		var list:Array<String> = [];
		for (f in fields) {
			if (f.meta.length > 0 && f.meta[0].name == 'chain') {
				//trace(f.name);
				//trace(f.kind.getParameters()[1].expr);
				var ex = { expr: f.kind.getParameters()[1].expr, pos:Context.currentPos() };
				exprs.push(macro list.push($i { f.name } = $e { ex }) );
				list.push(f.name);
			}
			f.kind.getParameters()[1] = null;
		}
		
		var i:Int = 0;
		for (e in list) {
			var next:Expr = list[i+1] == null ? macro null : macro $i{list[i+1]};
			var prev:Expr = list[i-1] == null ? macro null : macro $i{list[i-1]};
			exprs.push(macro $i { e } .chain($v { i }, $e{prev}, $e{next}, this));
			i++;
		}
		//trace(exprs);
		
		fields.push( {
			pos: Context.currentPos(),
			name: 'createChain',
			meta: [],
			doc: null,
			access: [APublic],
			kind: FFun({ret: null, params: [], args: [], expr: {expr:EBlock(exprs), pos: Context.currentPos()}})
		});
		#if display
		} catch (_:Dynamic) {
		}
		#end
		return fields;
	}
	
}