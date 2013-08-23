package pony.magic;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
#end
/**
 * Chain
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.ChainBuilder.build())
#end
interface Chain { }


class ChainBuilder {
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var exprs:Array<Expr> = [];
		var list:Array<String> = [];
		for (f in fields) {
			if (f.kind.getParameters()[1] != null) {
				//trace(f.name);
				//trace(f.kind.getParameters()[1].expr);
				var ex = { expr: f.kind.getParameters()[1].expr, pos:Context.currentPos() };
				exprs.push(macro $i { f.name } = $e { ex } );
				list.push(f.name);
			}
			f.kind.getParameters()[1] = null;
		}
		
		var i:Int = 0;
		for (e in list) {
			var next:Expr = list[i+1] == null ? macro null : macro $i{list[i+1]};
			var prev:Expr = list[i-1] == null ? macro null : macro $i{list[i-1]};
			exprs.push(macro $i { e } .chain($v { i }, $e{prev}, $e{next}));
			i++;
		}
		//trace(exprs);
		fields.push( {
			pos: Context.currentPos(),
			name: 'new',
			meta: [],
			doc: null,
			access: [APublic],
			kind: FFun({ret: null, params: [], args: [], expr: {expr:EBlock(exprs), pos: Context.currentPos()}})
		});
		
		return fields;
	}
	
}