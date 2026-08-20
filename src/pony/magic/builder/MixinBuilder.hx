package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ComplexTypeTools;
import haxe.macro.TypeTools;
#end

/**
 * MixinBuilder
 * @author AxGord <axgord@gmail.com>
 */
class MixinBuilder {

	#if macro
	private static final ready: Array<String> = [];
	#end

	macro public static function build(): Array<Field> {
		final fields: Array<Field> = Context.getBuildFields();
		final local = Context.getLocalClass();
		final localName: String = local.toString();
		if (ready.indexOf(localName) != -1) return fields;
		ready.push(localName);

		for (i in local.get().interfaces) {
			if (i.t.toString() == 'pony.magic.Mixin') {
				trace(i.params[0].getParameters()[0]);
				// todo
			}
		}

		return fields;
	}

}
