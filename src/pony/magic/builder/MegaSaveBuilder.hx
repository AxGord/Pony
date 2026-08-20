package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ComplexTypeTools;
import haxe.macro.TypeTools;
#end

/**
 * MegaSave Builder
 * @author AxGord <axgord@gmail.com>
 */
class MegaSaveBuilder {

	macro public static function build(): Array<Field> {
		final fields: Array<Field> = Context.getBuildFields();
		final localName: String = Context.getLocalClass().toString();
		for (field in fields) {
			switch field.kind {
				case FFun(fun):
					final method = macro $v{'Catch error($localName.${field.name}): '};
					if (fun.expr != null) switch [fun.expr.expr, fun.ret] {
						case [EBlock(exprs), TPath({ pack: [], name: 'Void' })], [EBlock(exprs), null]:
							fun.expr = macro try $b{exprs} catch (err: Dynamic) haxe.Log.trace($method + err, null);
						case [EBlock(exprs), _]:
							fun.expr = macro try $b{exprs} catch (err: Dynamic) {
								haxe.Log.trace($method + err, null);
								return null;
							};
						case _:
					}
				case _:
			}
		}
		return fields;
	}

}
