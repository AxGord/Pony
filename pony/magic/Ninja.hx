/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import haxe.macro.ComplexTypeTools;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import pony.macro.Tools;

using haxe.macro.Tools;
#end
/**
 * Ninja
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.NinjaBuilder.build())
#end
interface Ninja { }

class NinjaBuilder
{
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		
		var vars:Array<String> = [];
		var ninjaCreate:Bool = false;
		
		for (field in fields) {
			switch field.kind {
				case FVar(_): vars.push(field.name);
				case FFun(_) if (field.name == 'ninjaCreate'): ninjaCreate = true;
				case _:
			}
		}
		
		var used:Array<String> = [];
		
		for (field in fields) switch field.kind {
			case FFun(fun) if (check(field)):
				for (e in extract(fun.expr)) switch e.expr {
					case EBinop(OpAssign, {expr:EConst(CIdent(s)),pos:_}, _) if (vars.indexOf(s) != -1):
						used.push(s);
					case _:
				}
			case _:
		}
		
		for (field in fields) switch field.kind {
			case FFun(fun) if (check(field)):
				var a = extract(fun.expr);
				switch Context.getLocalType().toComplexType() {
					case TPath(p):
						var nowUsed = [];
						var na = [];
						for (e in a) switch e.expr {
							case EBinop(OpAssign, { expr:EConst(CIdent(s)), pos:_ }, e2) if (used.indexOf(s) != -1):
								var e1 = {expr: EField({expr: EConst(CIdent('__obj__')), pos:e2.pos}, s), pos: e2.pos};
								na.push(macro $e1 = $e2);
								nowUsed.push(s);
							case _: na.push(e);
						}
						if (ninjaCreate)
							na.unshift(macro var __obj__ = ninjaCreate());
						else
							na.unshift(macro var __obj__ = new $p());
						for (u in used) if (nowUsed.indexOf(u) == -1) {
							var e1 = { expr: EField( { expr: EConst(CIdent('__obj__')), pos:field.pos }, u), pos: field.pos };
							var e2 = { expr: EField( { expr: EConst(CIdent('this')), pos:field.pos }, u), pos: field.pos };
							na.push(macro $e1 = $e2);
						}
						na.push(macro return __obj__);
						fun.expr = { expr:EBlock(na), pos: field.pos };
					case _: throw 'error';
				}
				
			case _:
		}
		
		return fields;
	}
	#if macro
	private static function check(field:Field):Bool return Tools.checkMeta(field.meta, [':n', 'n', ':ninja', 'ninja']);
	private static function extract(e:Expr):Array<Expr> return switch e.expr { case EBlock(a): a; case _: [e]; };
	#end
}