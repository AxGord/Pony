package pony;

import haxe.macro.Context;

using Reflect;
using Lambda;
/**
 * ...
 * @author AxGord
 */
class Tools {

	
	macro public static function getBuildDate() {
        var date = Date.now().toString();
        return Context.makeExpr(date, Context.currentPos());
    }
	
	
	public static function equal(a:Dynamic, b:Dynamic):Bool {
		if (a == b) return true;
		for (f in a.fields())
			if (!b.hasField(f) || a.field(f) != b.field(f))
				return false;
		return true;
	}
	
	
}

class ArrayTools {
	
	public static function equal<T>(a:Array<T>, b:Array<T>):Bool {
		if (a == b) return true;
		for (i in 0...a.length) if (a[i] != b[i]) return false;
		return true;
	}
	
	public static function thereIs<T>(a:Iterable<Array<T>>, b:Array<T>):Bool {
		for (e in a) if (equal(e, b)) return true;
		return false;
	}
	
}

class FloatTools {
	public static function toFixed(v:Float, n:Int):String {
		if (n == 0) return Std.string(Std.int(v));
		var p:Float = Math.pow(10, n);
		v = Std.int(v * p) / p;
		var s:String = Std.string(v);
		var a:Array<String> = s.split('.');
		if (a.length <= 1)
			return s + '.' + StringTls.repeat('0', n);
		else
			return a[0] + '.' + a[1] + StringTls.repeat('0', n - a[1].length);
	}
}

class StringTls {
	public static function repeat(s:String, count:Int):String {
		var r:String = '';
		while (count-->0) r += s;
		return r;
	}
}