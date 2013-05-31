package pony.flash;
import pony.events.Signal;
import flash.external.ExternalInterface;
/**
 * ...
 * @author AxGord
 */
class Exterface extends Signal implements Dynamic<Exterface> {

	public static var get:Exterface = new Exterface();
	private static var map:Map<String, Exterface> = new Map<String, Exterface>();
	
	public var name(default, null):String;
	public var call:Dynamic;
	
	private function new(?name:String) {
		if (name != null) {
			super();
			this.name = name;
			ExternalInterface.addCallback(name, cb);
			map.set(name, this);
			call = Reflect.makeVarArgs(cll);
		}
	}
	
	private function cb(v:Array<Dynamic>):Void dispatchArgs(v);
	
	public function resolve(field:String):Exterface {
		var s:String = (name != null ? name + '.' : '') + field;
		return map.exists(s) ? map.get(s) : new Exterface(s);
	}
	
	private function cll(args:Array<Dynamic>):Dynamic {
		args.unshift(name);
		return Reflect.callMethod(null, ExternalInterface.call, args);
	}
	
}