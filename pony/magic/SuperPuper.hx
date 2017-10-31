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
package pony.magic;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
using Lambda;
using pony.macro.Tools;

#end
/**
 * SuperPuper
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.SuperPuperBuilder.build()) 
interface SuperPuper { }
#end
class SuperPuperBuilder {

	macro static public function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var lvl = 0;
		var sup = Context.getLocalClass().get().superClass;
		while (sup != null) {
			lvl++;
			for (field in sup.t.get().fields.get()) {
				var f = fields.find(checkName.bind(field.name));
				if (f == null) continue;
				if (field.meta.has(':puper')) 
					f.meta.push({
						name: ':puper',
						pos: f.pos,
						params: field.meta.extract(':puper')[0].params
					});
				else if (field.meta.has(':puper')) 
					f.meta.push({
						name: 'puper',
						pos: f.pos,
						params: field.meta.extract('puper')[0].params
					});
			}
			sup = sup.t.get().superClass;
		}
		
		if (Context.getLocalClass().get().meta.has(':final')) {
			for (field in fields) if (field.meta.checkMeta([':puper', 'puper'])) {
				switch field.kind {
					case FFun(fun):
						convertSuper(fun.expr, field.name, detectMethodLvl(field.name, lvl));
					case _: throw 'Only functions can be puper!';
				}
			}
			
			return fields;
		}
		
		for (field in fields) if (field.meta.checkMeta([':puper', 'puper'])) {
			var meta = field.meta.filter(function(m) return m.name != ':puper' && m.name != 'puper');
			fields.push({
				name: 'super${lvl}_'+field.name,
				access: [APrivate],
				pos: field.pos,
				kind: field.kind,
				meta: meta
			});
			switch field.kind {
				case FFun(fun):
					convertSuper(fun.expr, field.name, detectMethodLvl(field.name, lvl));
					var args = [for (arg in fun.args) macro $i { arg.name } ];
					var expr = macro return @await $i { 'super${lvl}_' + field.name } ($a { args } );
					field.kind = FFun({
						args : fun.args,
						ret : fun.ret,
						expr : expr,
						params : fun.params
					});		
				case _: throw 'Only functions can be puper!';
			}
		}
		
		return fields;
	}
	#if macro
	private static function detectMethodLvl(name:String, currentLvl:Int):Int {
		var sup = Context.getLocalClass().get().superClass;
		while (sup != null) {
			currentLvl--;
			if (sup.t.get().fields.get().exists(checkName.bind(name)))
				return currentLvl;
			sup = sup.t.get().superClass;
		}
		return -1;
	}
	
	private static function convertSuper(expr:Expr, fName:String, lvl:Int):Void {
		if (lvl == -1) return;
		switch expr.expr {
			case ECall({expr:EField({expr:EConst(CIdent('super')),pos:_}, fName),pos:pos},args):
				expr.expr = ECall( { expr:EConst(CIdent('super${lvl}_' + fName)), pos:pos }, args);
				
			case _:
				ExprTools.iter(expr, convertSuper.bind(_,fName,lvl));
		}
	}
	
	private static function checkName(name:String, field:Dynamic):Bool return field.name == name;
	#end
}