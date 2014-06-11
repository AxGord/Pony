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
			if (f.meta.getMeta('st') != null || f.meta.getMeta(':st') != null) {
				switch (f.kind) {
					case FVar(t, _):
						f.kind = FProp('get', 'never', t);
						fields.push( {
							name: 'get_'+f.name,
							kind: FFun( {
								args: [],
								ret: t,
								expr: macro return untyped this[$v{f.name}],
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