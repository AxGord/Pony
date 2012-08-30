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
import pony.macro.MacroTypes;

using Lambda;
using pony.macro.MacroExtensions;
using pony.Ultra;
#end

/**
 * Use this for get and set var in other object.
 * @example [@bind public var a:String = obj.a;]
 * @author AxGord
 */
#if !macro
@:autoBuild(pony.magic.BinderBuilder.build())
#end
interface Binder { }

/**
 * @author AxGord
 */
@:macro class BinderBuilder
{

	public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var newFields:Array<Field> = [];
		for (f in fields) switch (f.kind) {
			case FVar(t, e):
				if (f.meta.exists(function(m) return m.name.toLowerCase() == 'bind')) {
					if (f.access.indexOf(AStatic) == -1) {
						newFields.push( { pos: f.pos, name: f.name, meta: f.meta, doc: f.doc, access: f.access, kind:
							FProp('get' + f.name.bigFirst(), 'set' + f.name.bigFirst(), t)
						});
						newFields.push( { pos: f.pos, name: 'get' + f.name.bigFirst(), meta: [], doc: null, access: [APrivate, AInline], kind: FFun({
							ret: t,
							params: [],
							args: [],
							expr: {pos: f.pos, expr: EReturn(e)}
						}) } );
						newFields.push( { pos: f.pos, name: 'set' + f.name.bigFirst(), meta: [], doc: null, access: [APrivate, AInline], kind: FFun({
							ret: t,
							params: [],
							args: [{
								value: null,
								type: t,
								opt: false,
								name: 'value'
							}],
							expr: { pos: f.pos, expr: EReturn( { pos: f.pos, expr: EBinop(OpAssign, e, {pos: f.pos, expr: EConst(CIdent('value'))}) } ) }
						}) } );
					} else newFields.push(f);
				} else newFields.push(f);
			default: newFields.push(f);
		}
		return newFields;
	}
	
}