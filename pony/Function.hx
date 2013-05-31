package pony;

import haxe.macro.Expr;
import haxe.macro.Context;
import pony.macro.Tools;

using Lambda;
/**
 * Any function type!
 * @author AxGord
 */

abstract Function( { f:Dynamic, count:Int, args:Array<Dynamic>, id:Int, used:Int } ) {
	
	public static var unusedCount:Int = 0;
	//public static var list:Map<Int,Dynamic> = new Map<Int,Dynamic>();
	public static var list:Dictionary<Dynamic, Function> = new Dictionary<Dynamic, Function>();
	private static var counter:Int = -1;
	
	private static var searchFree:Bool = false;
	
	function new(f:Dynamic, count:Int, ?args:Array<Dynamic>) {
		counter++;
		if (searchFree) {//if counter make loop, then need search free id
			while (true) {
				for (e in list) {
					if (e.id() != counter)
						break;
				}
				counter++;
			}
		} else if (counter == -1)
			searchFree = true;
        this = { f:f, count:count, args:args == null?[]:args, id: counter, used: 0 };    
	}
	
	static public function from(f:Dynamic, argc:Int):Function {
		//var i:Int = list.indexOf(f);
		if (list.exists(f))
			return list.get(f);
		else {
			unusedCount++;
			var o:Function = new Function(f, argc);
			list.set(f, o);
			return o;
		}
	}
	
    @:from static public inline function from0<R>(f:Void->R)
        return from(f,0);
	
    @:from static public inline function from1<R>(f:Dynamic->R)
        return from(f, 1);
	
    @:from static public inline function from2<R>(f:Dynamic->Dynamic->R)
        return from(f,2);
	
    @:from static public inline function from3<R>(f:Dynamic->Dynamic->Dynamic->R)
        return from(f,3);
	
    @:from static public inline function from4<R>(f:Dynamic->Dynamic->Dynamic->Dynamic->R)
        return from(f,4);
	
    @:from static public inline function from5<R>(f:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->R)
        return from(f,5);
	
    @:from static public inline function from6<R>(f:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->R)
        return from(f, 6);
		
    @:from static public inline function from7<R>(f:Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->R)
        return from(f, 7);
		
	public inline function _call(args:Array<Dynamic>):Dynamic {
		return Reflect.callMethod(null, this.f, this.args.concat(args));
	}
	
	public inline function count():Int return this.count;
	
	//public inline function _bind(args:Array<Dynamic>):Function
	//	return new Function(this.f, this.count - args.length, this.args.concat(args));
		
	public inline function _setArgs(args:Array<Dynamic>):Void {
		this.count -= args.length;
		this.args = this.args.concat(args);
	}
	
	public inline function id():Int return this.id;
	
	//public inline function get():Dynamic return this.f;
		
	public inline function _use():Void {
		this.used++;
	}
	
	inline public function unuse():Void {
		this.used--;
		if (this.used <= 0) {
			list.remove(this.f);
			this = null;
			unusedCount--;
		}
	}
	
	inline public function used():Int return this.used;
}


class FunctionExtends {
	macro public static function call(f:ExprOf<Function>, a:Array < Expr > ):Expr
		return Tools.argsArrayAbstr(f, '_call', a);
	macro public static function bind(f:ExprOf<Function>, a:Array < Expr > ):Expr
		return Tools.argsArrayAbstr(f, '_bind', a);
	macro public static function setArgs(f:ExprOf<Function>, a:Array < Expr > ):Expr
		return Tools.argsArrayAbstr(f,'_setArgs',a);
}