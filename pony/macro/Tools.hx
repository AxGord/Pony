package pony.macro;
import haxe.macro.Expr;
/**
 * ...
 * @author AxGord
 */
#if macro
class Tools {

	public inline static function argsArray(func:Expr, args:Array<Expr>):Expr {
		args.shift();
		return macro $e{func} ($a{[[$a{args}]]});
	}
	
	public static function argsArrayAbstr(obj:ExprOf<Function>, name:String, args:Array < Expr > ):Expr {
		return macro $e{macro $ { obj } .$name} ($a{[[$a{args}]]});
	}
	
}
#end