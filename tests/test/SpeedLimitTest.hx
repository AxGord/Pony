package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.SpeedLimit;


/**
* Auto generated MassiveUnit Test Class 
*/

class SpeedLimitTest 
{	
	private var sl:SpeedLimit;
	private var c:Int;
	
	@Before
	public function setup():Void
	{
		sl = new SpeedLimit();
		c = 0;
	}
	
	@AsyncTest
	public function test(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, onTestAsyncComplete, 100);
		sl.run(testRun);//skiped
		sl.run(testRun);//skiped
		sl.run(handler);
	}
	
	private function testRun():Void c++
	
	private function onTestAsyncComplete():Void Assert.areEqual(0, c)

	//TODO: testing set delay in process
}
