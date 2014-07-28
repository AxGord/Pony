package magic;

import magic.NinjaTest.NinjaClass;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.Ninja;

class NinjaTest 
{
	@Test
	public function test():Void
	{
		var n = new NinjaClass(1);
		Assert.areEqual(n._number, 0);
		Assert.areEqual(n.def, 1);
		var n = n.number(5);
		Assert.areEqual(n.def, 1);
		Assert.areEqual(n._number, 5);
		var n = n.text('hello');
		Assert.areEqual(n.def, 1);
		Assert.areEqual(n._number, 5);
		Assert.areEqual(n._text, 'hello');
	}
}

class NinjaClass implements Ninja {
	
	public var _number:Int = 0;
	public var _text:String;
	public var def:Int;
	
	public function new(def) this.def = def;

	@:n public function number(n:Int):NinjaClass {
		_number = n;
	}
	
	@:n public function text(s:String):NinjaClass _text = s;
	
	public function ninjaCreate():NinjaClass return new NinjaClass(1);
	
}