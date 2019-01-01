package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.SuperPuper;

class SuperPuperTest 
{
	@Test
	public function testExample():Void
	{
		var obj = new SecondChildClass();
		var result = null;
		obj.test('Hello', function(r) result = r);
		Assert.areEqual(result, 'Hello world!');
	}
}


@:final class SecondChildClass extends ChildClass {
	
	override public function test(arg:String, cb:String->Void):Void {
		addSpace(arg, function(s) super.test(s, cb));
	}
	
	private function addSpace(arg:String, cb:String->Void):Void cb(arg+' ');
	
}

class ChildClass extends BaseClass {
	
	override public function test(arg:String, cb:String->Void):Void {
		addWorld(arg, function(s) super.test(s, cb));
	}
	
	private function addWorld(arg:String, cb:String->Void):Void cb(arg + 'world');
	
}

class BaseClass implements SuperPuper {
	
	public function new() {
		
	}
	
	@:puper public function test(arg:String, cb:String->Void):Void {
		cb(arg+'!');
	}
}