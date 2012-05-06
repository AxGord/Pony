package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.Polymorph;

enum MyEnum {q; w; e;}

class PolymorphTest implements Polymorph
{
	
	@Test
	public function simple() {
		Assert.areEqual('5', f(5));
		Assert.areEqual('qwe', f('qwe'));
		Assert.areEqual('2', f([1, 2, 3]));
		
		Assert.areEqual('3', f(['1', '2', '3']));
		
		Assert.areEqual('asd', f(function() return 'asd'));
		
		Assert.areEqual('erw', f( { name: 'erw', v: 2 } ));
		
		Assert.areEqual('ok', f(MyEnum.w));
	}
	
	static function f(i:Int):String return Std.string(i)
	
	static function f(s:String):String return s
	
	static function f(cb:Void->String):String return cb()
	
	static function f(s:Array<Int>):String return Std.string(s[1])
	
	static function f(s:Array<String>):String return Std.string(s[2])
	
	
	static function f(e:{name:String, v: Int}):String return e.name
	
	static function f(e:MyEnum):String return 'ok'
	
}