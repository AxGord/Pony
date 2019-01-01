package pony.db;

private enum DBVT {
	TInt; TString; TFun(fun:DBVF); TNull;
}

private enum DBVF {
	FNow;
}

/**
 * DBV
 * @author AxGord
 */
abstract DBV({type:DBVT, ?val:Dynamic})
{

	public static var NULL(get, never):DBV;
	public static var NOW(get, never):DBV;
	
	@:extern inline private function new(v) this = v;
	
	public function get(f:String->String):String {
		return switch this.type {
			case TString: f(this.val);
			case TInt: Std.string(this.val);
			case TFun(FNow): 'NOW()';
			case TNull: 'NULL';
		}
	}
	
	@:from @:extern inline public static function fromInt(v:Int):DBV return new DBV({type:TInt, val: v});
	@:from @:extern inline public static function fromString(v:String):DBV return new DBV({type:TString, val: v});
	@:extern inline private static function get_NOW():DBV return new DBV({type:TFun(FNow)});
	@:extern inline private static function get_NULL():DBV return new DBV({type:TNull});
	
}