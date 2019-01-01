package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
#end

/**
 * ChainBuilder
 * @author AxGord <axgord@gmail.com>
 */
class ChainBuilder {
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var ch = (Type.getClassName(Chain));
		var cl:String = null;
		for (i in Context.getLocalClass().get().interfaces) {
			if (i.t.toString() == ch) {
				cl = i.params[0].getParameters()[0].toString();
				break;
			}
		}
		if (cl == null) throw "Can't find type T (Chain<T>)";
		#if display
		try {
		#end
		var a = cl.split('.');
		var name = a.pop();
		
		fields.push( {
			pos: Context.currentPos(),
			name: 'list',
			meta: [],
			doc: null,
			access: [APublic],
			kind: FVar(TPath({name: 'Array', pack:[], params:[TPType(TPath({name: name, pack:a, params:[]}))]}))
		});
		
		var exprs:Array<Expr> = [Context.parse('list = new Array<$cl>()', Context.currentPos())];
		var list:Array<String> = [];
		for (f in fields) {
			if (f.meta.length > 0 && f.meta[0].name == 'chain') {
				//trace(f.name);
				//trace(f.kind.getParameters()[1].expr);
				var ex = { expr: f.kind.getParameters()[1].expr, pos:Context.currentPos() };
				exprs.push(macro list.push($i { f.name } = $e { ex }) );
				list.push(f.name);
			}
			f.kind.getParameters()[1] = null;
		}
		
		var i:Int = 0;
		for (e in list) {
			var next:Expr = list[i+1] == null ? macro null : macro $i{list[i+1]};
			var prev:Expr = list[i-1] == null ? macro null : macro $i{list[i-1]};
			exprs.push(macro $i { e } .chain($v { i }, $e{prev}, $e{next}, this));
			i++;
		}
		//trace(exprs);
		
		fields.push( {
			pos: Context.currentPos(),
			name: 'createChain',
			meta: [],
			doc: null,
			access: [APublic],
			kind: FFun({ret: null, params: [], args: [], expr: {expr:EBlock(exprs), pos: Context.currentPos()}})
		});
		#if display
		} catch (_:Dynamic) {
		}
		#end
		return fields;
	}
	
}