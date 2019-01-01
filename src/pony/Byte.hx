package pony;

/**
 * Byte
 * @author AxGord <axgord@gmail.com>
 */
abstract Byte(Int) from Int to Int {
	
	inline public static var b0001 = 1;
	inline public static var b0010 = 2;
	inline public static var b0100 = 4;
	inline public static var b1000 = 8;
	
	public var a(get, never):Int;
	public var b(get, never):Int;
	
	inline private function get_a():Int return this >> 4;
	inline private function get_b():Int return this & 0xF;
	
	inline static public function create(a:Int, b:Int):Byte return (a << 4) + b;
	
	inline public function chechSumWith(b:Byte):Byte return (this + (b:Int)) & 0xFF; 
	
	@:to inline public function toString():String return '0x' + StringTools.hex(this);
	
}