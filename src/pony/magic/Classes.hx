package pony.magic;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import sys.FileSystem;

using pony.macro.Tools;
#end

/**
 * Classes
 * @author AxGord
 */
class Classes {

	macro public static function dir(pack:String, dir:String):Expr {
		var f:String = Context.getPosInfos(Context.currentPos()).file;
		f = sys.FileSystem.fullPath(f).split('\\').slice(0, -1).join('/') + '/';
		var d:String = f + dir + '/';
		// trace(d);
		var list:Array<Expr> = [];
		var p:Array<String> = (pack != '' ? pack.split('.') : []).concat(dir.split('/'));
		for (e in FileSystem.readDirectory(d))
			if (e.substr(-3) == '.hx') {
				var ex:Expr = null;
				for (s in p)
					if (ex == null)
						ex = {expr: EConst(CIdent(s)), pos: Context.currentPos()};
					else
						ex = {expr: EField(ex, s), pos: Context.currentPos()};
				// trace(e.substr(0, e.length-3));
				ex = {expr: EField(ex, e.substr(0, e.length-3)), pos: Context.currentPos()};
				list.push(ex);
			}
		return {expr: EArrayDecl(list), pos: Context.currentPos()};
	}
	
}