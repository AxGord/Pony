package magic;

import massive.munit.Assert;
import pony.magic.StaticInit;
import pony.magic.StaticInitAll;

class StaticInitTest 
{
	#if !flash //problem with __init__ in flash/munit 
	@Test
	public function test():Void
	{
		Assert.isNull(SimpleStaticClass.someField);
		
		StaticInitAll.init();
		
		Assert.areEqual(SimpleStaticClass.someField, 'Hello');
		Assert.areEqual(SimpleStaticClass.fromGet, 'world');
		
		Assert.areEqual(SimpleStaticClass2.someField, 'Hi');
		Assert.areEqual(SimpleStaticClass2.fromGet, 'man');
		
		Assert.isNull(SimpleStaticClass3.someField);
		
		SimpleStaticClass3.initStatic();
		Assert.areEqual(SimpleStaticClass3.someField, 'wee');
	}
	#end
}

class SimpleStaticClass implements StaticInit {
	
	public static var someField:String = 'Hello';
	public static var emptyField:String;
	public static var fromGet:String = getStr('wo');
	
	private static function getStr(s:String):String return s + 'rld';
	
}

class SimpleStaticClass2 implements StaticInit {
	
	public static var someField:String = 'Hi';
	public static var emptyField:String;
	public static var fromGet:String = getStr('m');
	
	private static function getStr(s:String):String return s + 'an';
	
}
@:NotAll
class SimpleStaticClass3 implements StaticInit {
	
	public static var someField:String = 'wee';
	
}