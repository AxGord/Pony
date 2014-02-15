package magic;

import magic.DeclaratorTest.DeclaratorTestHelper;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Signal;
import pony.magic.Declarator;

class DeclaratorTest 
{	
	@Test
	public function staticInit():Void
	{
		Assert.areEqual(DeclaratorTestHelper.b, DeclaratorTestHelper.a);
		Assert.areEqual(DeclaratorTestHelper.b, 'hello');
	}
	
	@Test
	public function const():Void {
		var d = new DeclaratorTestHelper(5, 6);
		Assert.areEqual(d.sum(), 11);
		
		var d = new DeclaratorTestHelper(5);
		Assert.areEqual(d.sum(), 8);
	}
	
	@Test
	public function subEmpty():Void {
		var d = new DeclaratorTestHelperSub(3, 5, 6);
		Assert.areEqual(d.sum(), 33);
		
		var d = new DeclaratorTestHelperSub(2, 5);
		Assert.areEqual(d.sum(), 14);
	}
	
}

class DeclaratorTestHelper implements Declarator {
	static public var a:String = 'hello';
	static public var b:String;
	static public function __init__():Void b = a;
	
	@:arg private var i:Int;
	@:arg private var j:Int = 3;
	
	public function sum():Int return i + j;
	
}


class DeclaratorTestHelperSub extends DeclaratorTestHelper {
	@:arg private var v:Int;
	
	public function new(i:Int, j:Int=2) {
		super(i, j);
	}
	
	override public function sum():Int {
		return super.sum() * v;
	}
}
