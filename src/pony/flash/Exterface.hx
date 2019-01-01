package pony.flash;

import haxe.Log;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.PosInfos;

#if !macro
import flash.external.ExternalInterface;
import pony.events.Signal2;
#end

/**
 * Interface for ExternalInterface
 * @author AxGord
 */
class Exterface implements Dynamic<Exterface> implements pony.magic.HasSignal {
	
	public var name(default, null):String;
	
	#if !macro
	@:auto public var signal:Signal2<Dynamic, Dynamic>;
	public static var get:Exterface = new Exterface();
	private static var map:Map<String, Exterface> = new Map<String, Exterface>();
	
	private function new(?name:String) {
		if (name != null) {
			this.name = name;
			#if debug
			trace('Add callback: $name');
			#else
			ExternalInterface.addCallback(name, Reflect.makeVarArgs(dispatchArgs));
			#end
			map.set(name, this);
		}
	}
	
	private function dispatchArgs(a:Array<Dynamic>):Void eSignal.dispatch(a[0], a[1]);
	
	public static function regLog():Void {
		#if !debug
		Log.trace = function(m:Dynamic, ?p:PosInfos):Void get.log.call(p.fileName+':' + p.lineNumber + ': ' + m);
		#end
	}
	
	public function resolve(field:String):Exterface {
		var s:String = (name != null ? name + '.' : '') + field;
		return map.exists(s) ? map.get(s) : new Exterface(s);
	}
	
	public function callEmpty():Void {
		#if !debug
		ExternalInterface.call(name);
		#else
		trace('Call $name');
		#end
	}
	
	#end
	
	
	macro public function call(ethis : Expr, args:Array<Expr>):Expr {
		#if debug
		//var arr:Array<Expr> = [Context.makeExpr(args, Context.currentPos())];
		//var ae:Expr = Context.makeExpr(arr, Context.currentPos());
		//trace(ethis);
		return { expr: ECall({expr:EField(ethis,'_trace'), pos:Context.currentPos()}, [Context.makeExpr(args.length, Context.currentPos())]), pos: Context.currentPos()};
		#else
		args.unshift(macro $ethis.name);
		return macro flash.external.ExternalInterface.call($a { args } );
		#end
	}
	
	#if debug
	public function _trace(t:Dynamic):Dynamic {
		trace('Call $name: $t');
		return null;
	}
	#end
	
}