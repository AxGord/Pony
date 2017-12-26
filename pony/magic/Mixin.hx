package pony.magic;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ComplexTypeTools;
import haxe.macro.TypeTools;
#end

/**
 * Mixin
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.MixinBuilder.build())
#end
interface Mixin<T> {}

class MixinBuilder {

	#if macro
	private static var ready:Array<String> = [];
	#end
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var local = Context.getLocalClass();
		var localName:String = local.toString();
		if (ready.indexOf(localName) != -1) return fields;
		ready.push(localName);

		for (i in local.get().interfaces) {
			if (i.t.toString() == 'pony.magic.Mixin') {
				trace(i.params[0].getParameters()[0]);
				//todo
			}
		}

		return fields;
	}

}