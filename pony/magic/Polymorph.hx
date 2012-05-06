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
 * Use this interface for write overload functions.
 * @author AxGord
 */
#if !macro
@:autoBuild(pony.magic.PolymorphBuilder.build())
#end
interface Polymorph { }

/**
 * @author AxGord
 */

@:macro class PolymorphBuilder {
	
	static public function build():Array<Field> {
		var fields:Hash<Field> = new Hash<Field>();
		var dub:Hash<Array<Field>> = new Hash<Array<Field>>();
		for (f in Context.getBuildFields()) { //trace(f.name);
			if (fields.exists(f.name)) {
				dub.push(f.name, fields.get(f.name));
				fields.remove(f.name);
			}
			if (dub.exists(f.name))
				dub.push(f.name, f);
			else
				fields.set(f.name, f);
		}
		
		
		for (d in dub) {
			var z:Field = d[0];
			var t:ComplexType = TPath({sub: null, params: [], pack: [], name: 'Dynamic'});
			var v:FieldType;
			var a:Array<Expr> = [];
			for (f in d) {
				a.push(EFunction(null, f.kind.fun()).expr());
			}
			var ec:Expr = "pony.magic.PolymorphFunction.parse".typeCall([EArrayDecl(a).expr()]);// ECall(EField(EConst(CType('PolymorphFunction')).expr(), 'parse').expr(), [EArrayDecl(a).expr()]).expr();
			if (z.access.indexOf(AStatic) != -1) {
				v = FVar(t, ec);
				fields.set(z.name, { pos: z.pos, name: z.name, meta: z.meta, kind: v, doc: z.doc, access: z.access } );
				
				//todo: Better use dynamic function, and set in __init__
				
			} else {
				//v = FVar(t);
				//fields.set(z.name, { pos: z.pos, name: z.name, meta: z.meta, kind: v, doc: z.doc, access: z.access } );
				
				v = FFun( { ret: t, params: [], args: z.kind.fun().args, expr: EBlock([]).expr() } );
				var met:Metadata = z.meta;
				var sf:Bool = true;
				for (f in d) {
					if (sf) {
						sf = false;
						continue;
					}
					met.push({name:':overload', pos:Context.currentPos(), params: [EFunction(null, f.kind.fun()).expr()]});
				}
				
				fields.set(z.name, { pos: z.pos, name: z.name, meta: z.meta, kind: v, doc: z.doc, access: z.access.concat([ADynamic]) } );
				
				var a:Array<Expr> = fields.get('new').kind.fun().expr.expr.block();
				a.unshift(EBinop(OpAssign, EConst(CIdent(z.name)).expr(), ec).expr());
			}
		}
		
		
		return fields.array();
	}
	
}