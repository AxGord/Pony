/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

package pony.magic;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

using pony.macro.MacroExtensions;
using Lambda;
#end

/**
 * Methods can listen signals. Use meta @listen(signal, count, priority, delay).
 * @author AxGord
 */

#if !macro
@:autoBuild(pony.magic.ListenBuilder.build())
#end
interface Listen { }

/**
 * @author AxGord
 */
@:macro class ListenBuilder {
	
	public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var staticBlock:Array<Expr> = [];
		var block:Array<Expr> = [];
		var fInit:Field = null;
		var fNew:Field = null;
		for (f in fields) {
			if (f.name == '__init__')
				fInit = f;
			else if (f.name == 'new')
				fNew = f;
			else
			for (m in f.meta) if (m.name.toLowerCase() == 'listen') {
				var signal:Expr = m.params.shift();
				(f.access.indexOf(AStatic) == -1 ? block : staticBlock).push(ECall(EField(signal, 'addListener').expr(), [EConst(CIdent(f.name)).expr()].concat(m.params)).expr());
			}
		}
		
		if (block.length > 0) {
			if (fNew == null) {
				fields.push( fNew = { pos: Context.currentPos(), name: 'new', meta: [], kind: FFun( {
					ret: null, params: [], expr: EBlock([]).expr(), args: []
				}), doc: null, access: [APublic] } );
			}
			fNew.kind.fun().expr.expr.block().unshift(EBlock(block).expr());
		}
		
		if (staticBlock.length > 0) {
			fields.push({ pos: Context.currentPos(), name: '__listen__', meta: [], kind: FVar(null, EBlock(staticBlock).expr()), doc: null, access: [APrivate, AStatic] } );
		}
		
		
		return fields;
	}
	
}