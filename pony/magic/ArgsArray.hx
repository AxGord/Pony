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
import haxe.macro.Type;

using Lambda;
using pony.Ultra;
using pony.macro.MacroExtensions;
#end

/**
 * Use metadata @ArgsArray, for send all function arguments in first array argument.
 * @see Reflect.makeVarArgs
 * @author AxGord
 */
#if !macro
@:autoBuild(pony.magic.ArgsArrayBuilder.build())
#end
interface ArgsArray { }

/**
 * @author AxGord
 */
@:macro class ArgsArrayBuilder {
	
	public static function build():Array<Field> {
		var fields:Hash<Field> = new Hash<Field>();
		for (f in Context.getBuildFields()) {
			if (fields.exists(f.name))
				Context.error('Duplicate class field declaration: '+f.name, f.pos);
			fields.set(f.name, f);
		}
		
		for (f in fields) {
			
			if (f.meta.exists(function(e) return e.name == 'ArgsArray')) {
				fields.set(f.name, { pos: f.pos, name: f.name, meta: [], kind: FVar(TPath({sub: null, params: [], pack: [], name: 'Dynamic'})), doc: f.doc, access: f.access.concat([ADynamic]) } );
				fields.set('ArgsArray_' + f.name, { pos: f.pos, name: 'ArgsArray_' + f.name, meta: f.meta, kind: f.kind, doc: f.doc, access: f.access.indexOf(AStatic) != -1?[AStatic, APrivate]:[APrivate] } );
				
				if (f.access.indexOf(AStatic) != -1) {
					if (!fields.exists('__init__'))
						fields.set('__init__',  { pos: Context.currentPos(), name: '__init__', meta: [], kind: FFun( { ret: null, params: [], expr: EBlock([]).expr(), args: [] } ), doc: null, access: [AStatic] } );
					fields.get('__init__').kind.fun().expr.expr.block().push(EBinop(OpAssign, EConst(CIdent(f.name)).expr(), ECall(EField(EConst(CType('Reflect')).expr(), 'makeVarArgs').expr(), [EConst(CType('ArgsArray_' + f.name)).expr()]).expr()).expr());
					
				} else {
					//if (!fields.exists('new'))
					//	fields.set('new',  { pos: Context.currentPos(), name: 'new', meta: [], kind: FFun( { ret: null, params: [], expr: EBlock([]).expr(), args: [] } ), doc: null, access: [APublic] } );
					fields.get('new').kind.fun().expr.expr.block().unshift(EBinop(OpAssign, EConst(CIdent(f.name)).expr(), ECall(EField(EConst(CType('Reflect')).expr(), 'makeVarArgs').expr(), [EConst(CIdent('ArgsArray_' + f.name)).expr()]).expr()).expr());
				}
			} else
				fields.set(f.name, f);
		}
		
		return fields.array();
	}
	
}