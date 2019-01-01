package pony.physics;

/**
 * Temp
 * @author AxGord <axgord@gmail.com>
 */
abstract Temp(Float) {

	public var k(get,never):Float;
	public var c(get,never):Float;
	
	inline public function new(k:Float) this = k;
	
	@:to inline private function get_k():Float return this;
	inline private function get_c():Float return this - 273.15;
	
	@:from inline static public function fromK(k:Float):Temp return new Temp(k);
	
	inline static public function fromC(c:Float):Temp return new Temp(c+273.15);
	
	@:from static public function fromString(s:String):Temp {
		s = StringTools.trim(s);
		var ch = s.substr(s.length - 1).toLowerCase();
		var v:Float = Std.parseFloat(s.substr(0, s.length - 1));
		return switch ch {
			case 'c': fromC(v);
			case 'k': fromK(v);
			case _: throw 'Unknown temp measure';
		}
	}
	
	@:to inline private function toString():String return c + 'C';
	
	
}