package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.StaticInit;

class StaticInitTest 
{
	@Test
	public function test():Void
	{
		Assert.isNull(SimpleStaticClass.someField);
		SimpleStaticClass.initStatic();
		Assert.areEqual(SimpleStaticClass.someField, 'Hello');
		Assert.areEqual(SimpleStaticClass.fromGet, 'world');
	}
}

class SimpleStaticClass implements StaticInit {
	
	public static var someField:String = 'Hello';
	public static var emptyField:String;
	public static var fromGet:String = getStr('wo');
	
	private static function getStr(s:String):String return s + 'rld';
	
}