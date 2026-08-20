package pony.macro;

#if (macro || dox)
import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;

/**
 * Macro Tools
 * @author AxGord
 */
@:nullSafety(Strict) class Tools {

	public static var staticPlatform: Bool = Context.defined('cs') || Context.defined('flash') || Context.defined('java');

	public static inline function argsArray(func: Expr, args: Array<Expr>): Expr {
		args.shift();
		return macro $e{func}($a{[[$a{args}]]});
	}

	public static function argsArrayAbstr(obj: ExprOf<Function>, name: String, args: Array<Expr>): Expr {
		return macro $e{macro ${obj}.$name}($a{[[$a{args}]]});
	}

	public static function getMeta(a: Metadata, n: String, addHidding: Bool = false): MetadataEntry {
		if (a == null) return null;
		return a.find(e -> e.name == n || (addHidding && e.name == ':$n'));
	}

	public static function checkMeta(a: Metadata, an: Array<String>): Bool {
		for (n in an) if (getMeta(a, n) != null) return true;
		return false;
	}

	public static function createInit(): Field {
		return {
			name: '__init__',
			access: [AStatic, APrivate],
			kind: FFun({ args: [], ret: ComplexType.TPath({ pack: [], name: 'Void' }), expr: null }),
			pos: Context.currentPos()
		};
	}

	public static function createNew(): Field {
		return {
			name: 'new',
			access: [APublic],
			kind: FFun({ args: [], ret: ComplexType.TPath({ pack: [], name: 'Void' }), expr: null }),
			pos: Context.currentPos()
		};
	}

	public static function patch(?newFields: ComplexType, ?methods: Map<String, Expr>, ?addToEnd: Map<String, Expr>): Array<Field> {
		var fields: Array<Field> = Context.getBuildFields();
		if (methods != null || addToEnd != null) for (field in fields) {
			if (methods != null) {
				final ex: Null<Expr> = methods[field.name];
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
				final ex: Null<Expr> = addToEnd[field.name];
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

	public static function replaceToBlock(e: Expr): Expr {
		return switch e.expr {
			case EBlock(_): e;
			case _: macro $b{[e]};
		}
	}

	/**
	 * Walk expression tree and wrap every `return` with `beforeReturn` expression so cleanup
	 * code runs on every return path. Return value is preserved via a local temporary.
	 * Nested functions are NOT traversed — their `return` belongs to the inner function scope.
	 */
	public static function rewriteReturns(e: Expr, beforeReturn: Expr): Expr {
		return switch e.expr {
			case EReturn(null):
				macro {
					$beforeReturn;
					return;
				};
			case EReturn(v):
				macro {
					final __r = $v;
					$beforeReturn;
					return __r;
				};
			case EFunction(_, _):
				e;
			case _:
				haxe.macro.ExprTools.map(e, sub -> rewriteReturns(sub, beforeReturn));
		};
	}

	/**
	 * Check whether an expression tree contains a reference to the given identifier.
	 * Nested functions are skipped — a reference inside a lambda doesn't count.
	 */
	public static function containsIdent(e: Expr, name: String): Bool {
		return switch e.expr {
			case EConst(CIdent(n)) if (n == name): true;
			case EFunction(_, _): false;
			case _:
				var found: Bool = false;
				haxe.macro.ExprTools.iter(e, sub -> if (!found && containsIdent(sub, name)) found = true);
				found;
		};
	}

	/**
	 * Check whether an expression tree contains a direct call to the given function name.
	 * Nested functions are skipped — a call inside a lambda doesn't count as the outer
	 * function calling `name`.
	 */
	public static function containsCall(e: Expr, name: String): Bool {
		return switch e.expr {
			case ECall({ expr: EConst(CIdent(n)) }, _) if (n == name):
				true;
			case EFunction(_, _):
				false;
			case _:
				var found: Bool = false;
				haxe.macro.ExprTools.iter(e, sub -> if (!found && containsCall(sub, name)) found = true);
				found;
		};
	}

}
#end
