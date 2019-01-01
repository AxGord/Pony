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