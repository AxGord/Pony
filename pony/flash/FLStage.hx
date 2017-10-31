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

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
using pony.macro.Tools;
#end

/**
 * FLSt
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.flash.FLStageBuilder.build())
#end
interface FLStage { }

class FLStageBuilder {
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		for (f in fields) {
			var m = f.meta.getMeta('stage', true);
			
			if (m != null) {
				var allowSet = false;
				for (p in m.params) switch p.expr {
					case EConst(CIdent('set')): allowSet = true;
					case _:
				}
				
				switch (f.kind) {
					case FVar(t, _):
						f.kind = FProp('get', allowSet ? 'set' : 'never', t);
						fields.push( {
							name: 'get_'+f.name,
							kind: FFun( {
								args: [],
								ret: t,
								#if openfl
								expr: macro return untyped getChild($v { f.name } ),
								#else
								expr: macro return untyped this.getChildByName($v { f.name } ),
								#end
								params: []
							}),
							pos: f.pos,
							access: [AInline, APrivate]
						});
						if (allowSet)//Only flash!
							fields.push( {
								name: 'set_'+f.name,
								kind: FFun( {
									args: [{name:'v',type:t}],
									ret: t,
									expr: macro return untyped this[$v{f.name}] = v,
									params: []
								}),
								pos: f.pos,
								access: [AInline, APrivate]
							});
					case _:
				}
			}
		}
		return fields;
	}
	
}