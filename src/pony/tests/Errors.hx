package pony.tests;

/**
 * Errors
 * @author AxGord <axgord@gmail.com>
 */
class Errors {

	public var result: Map<String, String> = [];
	public var arg: String;

	public function new() {}

	public inline function test(cond: Bool, message: String): Void {
		if (cond && !result.exists(arg)) set(message);
	}

	public inline function set(message: String): Void {
		result[arg] = message;
	}

	public inline function empty(): Bool return !result.iterator().hasNext();

}
