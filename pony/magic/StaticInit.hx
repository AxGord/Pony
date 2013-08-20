package pony.magic;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
#end
/**
 * StaticInit
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.StaticInitBuilder.build())
#end
interface StaticInit {}

class StaticInitBuilder {
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var exprs:Array<Expr> = [];
		for (f in fields) {
			if (f.kind.getParameters()[1] != null) {
				//trace(f.name);
				//trace(f.kind.getParameters()[1].expr);
				var ex = { expr: f.kind.getParameters()[1].expr, pos:Context.currentPos() };
				exprs.push(macro $i{f.name} = $e{ex});
			}
			f.kind.getParameters()[1] = null;
		}
		//trace(exprs);
		fields.push( {
			pos: Context.currentPos(),
			name: 'initStatic',
			meta: [],
			doc: null,
			access: [APublic, AStatic, AInline],
			kind: FFun({ret: null, params: [], args: [], expr: {expr:EBlock(exprs), pos: Context.currentPos()}})
		});
		//trace(fields);
		return fields;
	}
	
}