package pony.magic.builder;

#if macro
import haxe.macro.ComplexTypeTools;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import pony.macro.Tools;
#end

/**
 * DeclaratorBuilder
 * todo: inlines
 * @author AxGord <axgord@gmail.com>
 */
class DeclaratorBuilder {

	macro public static function build():Array<Field> {
		var fields:Array<Field> = [];
		var toInit:Array<Expr> = [];
		var toNew:Array<Expr> = [];
		var fInit:Field;
		var fNew:Field;
		var args:Array<FunctionArg> = [];
		for (f in Context.getBuildFields()) {
			switch [f.kind, f.name] {
				case [FVar(t, e), _] if (Lambda.indexOf(f.access, AInline) == -1):
					f.kind = FVar(t, null);
					if (Tools.checkMeta(f.meta, [':arg', 'arg'])) {
						var n = f.name;
						switch ComplexTypeTools.toString(t) {
							case 'Int' | 'Float' if (Tools.staticPlatform):
								args.push( { name: n, opt: false, type: t, value: macro $e } );
								toNew.push(macro this.$n = $i{n});
							case _:
								args.push( { name: n, opt: e != null, type: t } );
								if (e == null) toNew.push(macro this.$n = $i {n} );
								else toNew.push(macro this.$n = $i{n} != null ? $i{n} : $i{n} = $e);
						}

					} else if (e != null) {
						var t = Lambda.indexOf(f.access, AStatic) == -1 ? toNew : toInit;
						t.push(macro $i { f.name } = $e);
					}
				case [FProp(g, s, t, e), _] if (s != 'set'):
					f.kind = FProp(g, s, t, null);
					if (Tools.checkMeta(f.meta, [':arg', 'arg'])) {
						var n = f.name;
						switch ComplexTypeTools.toString(t) {
							case 'Int' | 'Float' if (Tools.staticPlatform):
								args.push( { name: n, opt: false, type: t, value: macro $e } );
								toNew.push(macro this.$n = $i{n});
							case _:
								args.push( { name: n, opt: e != null, type: t } );
								if (e == null) toNew.push(macro this.$n = $i {n} );
								else toNew.push(macro this.$n = $i{n} != null ? $i{n} : $i{n} = $e);
						}
					} else if (e != null) {
						var t = Lambda.indexOf(f.access, AStatic) == -1 ? toNew : toInit;
						t.push(macro $i { f.name } = $e);
					}
				case [FFun(fun), '__init__']:
					fInit = f;
				case [FFun(fun), 'new']:
					fNew = f;
				case _:
			}
			fields.push(f);
		}
		if (fInit == null) {
			fInit = Tools.createInit();
			fields.push(fInit);
		}
		switch fInit.kind {
			case FFun(k):
				if (k.expr != null) switch k.expr.expr {
					case EBlock(a): toInit = toInit.concat(a);
					case _: toInit.push(k.expr);
				}
				k.expr = macro $b{toInit};
			case _: throw 'Error';
		}

		if (fNew == null) {
			var s = (Context.getLocalClass().get().superClass);
			if (s != null) {
				if (haveArgs(s.t.get().constructor.get().type)) {
					toNew.push(macro super());
				}
			}

			fNew = Tools.createNew();
			fields.push(fNew);
		}
		switch fNew.kind {
			case FFun(k):
				k.args = args.concat(k.args);

				if (k.expr != null) switch k.expr.expr {
					case EBlock(a): toNew = toNew.concat(a);
					case _: toNew.push(k.expr);
				}

				k.expr = macro $b{toNew};
			case _: throw 'Error';
		}
		return fields;
	}
	#if macro
	private static function haveArgs(t:Type):Bool return switch t {
		case Type.TFun(args, _): args.length == 0;
		case Type.TLazy(f): haveArgs(f());
		case _: false;
	}
	#end
}