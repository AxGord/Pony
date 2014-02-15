package magic;

import massive.munit.Assert;
import pony.magic.StaticInit;

class StaticInitTest 
{
	//#if !flash //problem with __init__ in flash/munit 
	@Test
	public function test():Void
	{
		Assert.areEqual(SimpleStaticClass.someField, 'Hello');
		Assert.areEqual(SimpleStaticClass.fromGet, 'world');
		
		Assert.areEqual(SimpleStaticClass2.someField, 'Hi');
		Assert.areEqual(SimpleStaticClass2.fromGet, 'man');
		
		Assert.areEqual(SimpleStaticClass3.someField, 'wee');
	}
	//#end
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
class SimpleStaticClass3 implements StaticInit {
	
	public static var someField:String = 'wee';
	
}