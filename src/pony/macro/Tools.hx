package pony.macro;

#if (macro || dox)
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * Macro Tools
 * @author AxGord
 */
@:nullSafety(Strict) class Tools {

	public static var staticPlatform:Bool = Context.defined('cs') || Context.defined('flash') || Context.defined('java');

	public inline static function argsArray(func:Expr, args:Array<Expr>):Expr {
		args.shift();
		return macro $e{func} ($a{[[$a{args}]]});
	}

	public static function argsArrayAbstr(obj:ExprOf<Function>, name:String, args:Array < Expr > ):Expr {
		return macro $e{macro ${ obj }.$name} ($a{[[$a{args}]]});
	}

	public static function getMeta(a:Metadata, n:String, addHidding:Bool=false):MetadataEntry {
		if (a == null) return null;
		for (e in a) if (e.name == n || (addHidding && e.name == ':' + n)) return e;
		return null;
	}

	public static function checkMeta(a:Metadata, an:Array<String>):Bool {
		for (n in an) if (getMeta(a, n) != null) return true;
		return false;
	}

	public static function createInit():Field {
		return {
			name: '__init__',
			access: [AStatic, APrivate],
			kind: FFun({args:[], ret: ComplexType.TPath({pack:[],name:'Void'}), expr: null}),
			pos: Context.currentPos()
		};
	}

	public static function createNew():Field {
		return {name: 'new', access: [APublic], kind: FFun({args:[], ret: ComplexType.TPath({pack:[],name:'Void'}), expr: null}), pos: Context.currentPos()};
	}

	public static function patch(?newFields: ComplexType, ?methods: Map<String, Expr>, ?addToEnd: Map<String, Expr>): Array<Field> {
		var fields: Array<Field> = Context.getBuildFields();
		if (methods != null || addToEnd != null) for (field in fields) {
			if (methods != null) {
				var ex: Null<Expr> = methods[field.name];
				if (ex != null) {
					switch field.kind {
						case FFun(f):
							f.expr = ex;
						case _:
							Context.error('This is not method', field.pos);
					}
				}
			}
			if (addToEnd != null) {
				var ex: Null<Expr> = addToEnd[field.name];
				if (ex != null) {
					switch field.kind {
						case FFun(f):
							switch f.expr.expr {
								case EBlock(exprs):
									exprs.push(ex);
								case _:
									Context.error('This is not block method', f.expr.pos);
							}
						case _:
							Context.error('This is not method', field.pos);
					}
				}
			}
		}
		switch newFields {
			case TAnonymous(f):
				fields = fields.concat(f);
			case null:
			case _:
				Context.error('Wrong type', Context.currentPos());
		}
		return fields;
	}

}
#end