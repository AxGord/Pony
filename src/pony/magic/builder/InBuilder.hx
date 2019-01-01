package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import pony.macro.Tools;

using Lambda;
#end

/**
 * InBuilder
 * @author AxGord <axgord@gmail.com>
 */
class InBuilder {
	
	macro public static function build():Array<Field> {
		var fs:Array<Field> = Context.getBuildFields();
		for (f in fs) switch f.kind {
			case FFun(f):
				f.expr = ExprTools.map(f.expr, repl);
			case _:
		}
		return fs;
	}

	#if macro
	static public function repl(e:Expr):Expr {
		return switch e.expr {
			#if (haxe_ver >= "4.0.0")
			case EBinop(OpIn, e1, e2):
			#else
			case EIn(e1, e2):
			#end
				macro $e2.indexOf($e1) != -1;
			case EFor(_, _): e;
			case _: ExprTools.map(e, repl);
		};
	}
	#end
	
}