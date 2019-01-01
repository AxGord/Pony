package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
#end

/**
 * StaticInitBuilder
 * @author AxGord <axgord@gmail.com>
 */
class StaticInitBuilder {
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var exprs:Array<Expr> = [];
		for (f in fields) if (f.access.indexOf(AInline) == -1) {
			if (f.kind.getParameters()[1] != null) {
				var ex = { expr: f.kind.getParameters()[1].expr, pos:Context.currentPos() };
				exprs.push(macro $i{f.name} = $e{ex});
			}
			f.kind.getParameters()[1] = null;
		}
		fields.push( {
			pos: Context.currentPos(),
			name: '__init__',
			meta: [],
			doc: null,
			access: [APrivate, AStatic, AInline],
			kind: FFun({ret: null, params: [], args: [], expr: {expr:EBlock(exprs), pos: Context.currentPos()}})
		});
		return fields;
	}
	
}