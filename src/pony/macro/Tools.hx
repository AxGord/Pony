package pony.macro;

#if (macro || dox)
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * ...
 * @author AxGord
 */
class Tools {
	
	public static var staticPlatform:Bool = Context.defined('cs') || Context.defined('flash') || Context.defined('java');

	public inline static function argsArray(func:Expr, args:Array<Expr>):Expr {
		args.shift();
		return macro $e{func} ($a{[[$a{args}]]});
	}
	
	public static function argsArrayAbstr(obj:ExprOf<Function>, name:String, args:Array < Expr > ):Expr {
		return macro $e{macro $ { obj } .$name} ($a{[[$a{args}]]});
	}
	
	public static function getMeta(a:Metadata, n:String, addHidding:Bool=false):MetadataEntry {
		if (a == null) return null;
		for (e in a) if (e.name == n || (addHidding && e.name == ':'+n)) return e;
		return null;
	}
	
	public static function checkMeta(a:Metadata, an:Array<String>):Bool {
		for (n in an) if (getMeta(a, n) != null) return true;
		return false;
	}
	
	public static function createInit():Field {
		return {name: '__init__', access: [AStatic, APrivate], kind: FFun({args:[], ret: ComplexType.TPath({pack:[],name:'Void'}), expr: null}), pos: Context.currentPos()};
	}
	
	public static function createNew():Field {
		return {name: 'new', access: [APublic], kind: FFun({args:[], ret: ComplexType.TPath({pack:[],name:'Void'}), expr: null}), pos: Context.currentPos()};
	}
	
}
#end