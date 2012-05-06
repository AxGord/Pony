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
#end

/**
 * Use this for set var without consrtuctor.
 * @arg - for make field as argument in consructor.
 * @author AxGord
 */
#if !macro
@:autoBuild(pony.magic.DeclaratorBuilder.build())
#end
interface Declarator { }

/**
 * ...
 * @author AxGord
 */
@:macro class DeclaratorBuilder
{

	 public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		if (Context.getLocalClass().get().isInterface) return fields;
		var fNew:Field = null;
		var dBlock:Array<Expr> = [];
		var args:Array<FunctionArg> = [];
		for (f in fields) {
			switch (f.kind) {
				case FVar(t, e):
					if (f.access.indexOf(AStatic) == -1) {
						if (f.meta.exists(function(m) return m.name.toLowerCase() == 'arg')) {
							args.push({name: f.name, value: e, type: t, opt: false});
							dBlock.push(EBinop(OpAssign, EField(EConst(CIdent('this')).expr(), f.name).expr(), EConst(CIdent(f.name)).expr()).expr());
						} else if (e != null) {
							dBlock.push(EBinop(OpAssign, EConst(CIdent(f.name)).expr(), e).expr());
						}
						//trace(f.name);
						//trace(t);
						f.kind = FVar(t==null?MacroTypes._dynamic:t, null);
					}
				case FFun(Void):
					if (f.name == 'new') {
						fNew = f;
					}
				case FProp(get, set, t, e):
					if (f.access.indexOf(AStatic) == -1) {
						if (f.meta.exists(function(m) return m.name.toLowerCase() == 'arg')) {
							args.push({name: f.name, value: e, type: t, opt: false});
							dBlock.push(EBinop(OpAssign, EField(EConst(CIdent('this')).expr(), f.name).expr(), EConst(CIdent(f.name)).expr()).expr());
						} else if (e != null) {
							dBlock.push(EBinop(OpAssign, EConst(CIdent(f.name)).expr(), e).expr());
						}
						f.kind = FProp(get, set, t==null?MacroTypes._dynamic:t, null);
					}
				default:
			}
		}
		if (fNew == null) {
			var cargs : Array<FunctionArg> = [];
			var ce:Array<Expr> = [];
			var lc:ClassType = Context.getLocalClass().get();
			var s = lc.superClass;
			
			if (s != null) {
				
				var h:Hash<ComplexType> = new Hash<ComplexType>();
				var i:Int = 0;
				
				if (s.params.length != s.t.get().params.length)
					Context.error('Not set parsms', lc.pos);
					
				for (p in s.t.get().params) {
					h.set(p.name, s.params[i++].toComplexType());
				}
				//trace(h);
				//h = new Hash<ComplexType>();
				//trace(h);
				//trace(s.t.get().constructor.get().type.fun().args);
				var params:Array<Expr> = [];
				switch (s.t.get().constructor.get().type) {
					case TFun(args, Void):
						for (arg in args) {
							var ct:ComplexType = arg.t.toComplexType();
							if (h.exists(ct.typePath().name))
								ct = h.get(ct.typePath().name);
							cargs.push( { name: arg.name, opt: arg.opt, type: ct, value: null } );
							params.push(EConst(CIdent(arg.name)).expr());
						}
					case TLazy(f):
						switch(f()) {
							case TFun(args, Void):
								for (arg in args) {
									var ct:ComplexType = arg.t.toComplexType();
									if (h.exists(ct.typePath().name))
										ct = h.get(ct.typePath().name);
									cargs.push( { name: arg.name, opt: arg.opt, type: ct, value: null } );
									params.push(EConst(CIdent(arg.name)).expr());
								}
							default:
						}
					default:
				}
				ce.push(ECall(EConst(CIdent('super')).expr(), params).expr());
			}
			
			fields.push( fNew = { pos: Context.currentPos(), name: 'new', meta: [{name: 'NotAsyncAuto', params: [], pos: Context.currentPos()}], kind: FFun( {
				ret: null, params: [], expr: EBlock(ce).expr(), args: cargs
			}), doc: null, access: [APublic] } );
		}
		
		fNew.kind.fun().expr.expr.block().unshift(EBlock(dBlock).expr());
		
		fNew.kind.fun().args = args.concat(fNew.kind.fun().args);
		return fields;
	}
	
}