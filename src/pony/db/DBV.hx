package pony.db;

private enum DBVT {
	TInt;
	TString;
	TFun(fun: DBVF);
	TNull;
}

private enum DBVF {
	FNow;
	FUnixTimeStamp;
}

/**
 * DBV
 * @author AxGord
 */
@SuppressWarnings('checkstyle:MagicNumber')
abstract DBV({type: DBVT, ? val : Dynamic}) {

	public static var NULL(get, never): DBV;
	public static var NOW(get, never): DBV;
	public static var TIMESTAMP(get, never): DBV;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function new(v) this = v;

	public function get(f: String -> String): String {
		return switch this.type {
			case TString: f(this.val);
			case TInt: Std.string(this.val);
			case TFun(FNow): 'NOW()';
			case TFun(FUnixTimeStamp): 'UNIX_TIMESTAMP()';
			case TNull: 'NULL';
		}
	}

	@:from #if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromInt(v: Int): DBV return new DBV({type: TInt, val: v});

	@:from #if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromString(v: String): DBV return new DBV({type: TString, val: v});

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function get_NOW(): DBV return new DBV({type: TFun(FNow)});

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function get_TIMESTAMP(): DBV return new DBV({type: TFun(FUnixTimeStamp)});

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function get_NULL(): DBV return new DBV({type: TNull});

}