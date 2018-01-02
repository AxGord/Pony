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
package pony.magic;

#if macro
import haxe.macro.ComplexTypeTools;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import pony.macro.Tools;
#end


/**
 * Use this for set args without constructor and replays set var to new or __init__ functions.
 * "@arg" or "@:arg" - for make field as argument in consructor.
 * todo: inlines
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.DeclaratorBuilder.build())
#end
interface Declarator { }

class DeclaratorBuilder
{
	macro public static function build():Array<Field> {
		var fields:Array<Field> = [];
		var toInit:Array<Expr> = [];
		var toNew:Array<Expr> = [];
		var fInit:Field;
		var fNew:Field;
		var args:Array<FunctionArg> = [];
		for (f in Context.getBuildFields()) {
			switch [f.kind, f.name] {
				case [FVar(t, e), _]:
					f.kind = FVar(t, null);
					if (Tools.checkMeta(f.meta, [':arg', 'arg'])) {
						var n = f.name;
						switch ComplexTypeTools.toString(t) {
							case 'Int' | 'Float' if (Tools.staticPlatform):
								args.push( { name: n, opt: false, type: t, value: macro $e } );
								toNew.push(macro this.$n = $i{n});
							case _:
								args.push( { name: n, opt: e != null, type: t } );
								if (e == null) toNew.push(macro this.$n = $i {n} );
								else toNew.push(macro this.$n = if ($i{n} != null) $i{n} else $i{n} = $e);
						}
						
					} else if (e != null) {
						var t = Lambda.indexOf(f.access, AStatic) == -1 ? toNew : toInit;
						t.push(macro $i { f.name } = $e);
					}
				case [FProp(g, s, t, e), _] if (s != 'set'):
					f.kind = FProp(g,s, t, null);
					if (Tools.checkMeta(f.meta, [':arg', 'arg'])) {
						var n = f.name;
						switch ComplexTypeTools.toString(t) {
							case 'Int' | 'Float' if (Tools.staticPlatform):
								args.push( { name: n, opt: false, type: t, value: macro $e } );
								toNew.push(macro this.$n = $i{n});
							case _:
								args.push( { name: n, opt: e != null, type: t } );
								if (e == null) toNew.push(macro this.$n = $i {n} );
								else toNew.push(macro this.$n = if ($i{n} != null) $i{n} else $i{n} = $e);
						}
					} else if (e != null) {
						var t = Lambda.indexOf(f.access, AStatic) == -1 ? toNew : toInit;
						t.push(macro $i { f.name } = $e);
					}
				case [FFun(fun), '__init__']:
					fInit = f;
				case [FFun(fun), 'new']:
					fNew = f;
				case _:
			}
			fields.push(f);
		}
		if (fInit == null) {
			fInit = Tools.createInit();
			fields.push(fInit);
		}
		switch fInit.kind {
			case FFun(k):
				if (k.expr != null) switch k.expr.expr {
					case EBlock(a): toInit = toInit.concat(a);
					case _: toInit.push(k.expr);
				}
				k.expr = macro $b{toInit};
			case _: throw 'Error';
		}
		
		if (fNew == null) {
			var s = (Context.getLocalClass().get().superClass);
			if (s != null) {
				if (haveArgs(s.t.get().constructor.get().type)) {
					toNew.push(macro super());
				}
			}
			
			fNew = Tools.createNew();
			fields.push(fNew);
		}
		switch fNew.kind {
			case FFun(k):
				k.args = args.concat(k.args);
				
				if (k.expr != null) switch k.expr.expr {
					case EBlock(a): toNew = toNew.concat(a);
					case _: toNew.push(k.expr);
				}
				
				
				
				k.expr = macro $b{toNew};
			case _: throw 'Error';
		}
		return fields;
	}
	#if macro
	private static function haveArgs(t:Type):Bool return switch t {
		case Type.TFun(args, _): args.length == 0;
		case Type.TLazy(f): haveArgs(f());
		case _: false;
	}
	#end
}