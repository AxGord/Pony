package pony.magic.builder;

#if macro
import haxe.macro.Expr;

using Lambda;
using haxe.macro.ComplexTypeTools;
using pony.macro.Tools;
#end

/**
 * WRBuilder
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) final class WRBuilder {

	macro public static function build(): Array<Field> {
		return Tools.patch(macro: {

			private final _waitReady: pony.events.WaitReady = new pony.events.WaitReady();

			private inline function ready(): Void _waitReady.ready();
			public function waitReady(cb: () -> Void): Void _waitReady.wait(cb);

		});
	}

}