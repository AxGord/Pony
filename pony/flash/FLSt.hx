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
@:autoBuild(pony.flash.FLStBuilder.build())
#end
interface FLSt { }

class FLStBuilder {
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		for (f in fields) {
			var m = f.meta.getMeta('st', true);
			
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
								expr: macro return untyped getChildByName($v { f.name } ),
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