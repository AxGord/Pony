package pony.tests;

/**
 * Errors
 * @author AxGord <axgord@gmail.com>
 */
class Errors {

	public var arg:String;
	public var result:Map<String, String>;
	
	public function new() {
		result = new Map<String, String>();
	}
	
	public inline function test(cond:Bool, message:String) {
		if (cond && !result.exists(arg)) set(message);
	}
	
	public inline function set(message:String):Void {
		result.set(arg, message);
	}
	
	public inline function empty():Bool return !result.iterator().hasNext();
	
}