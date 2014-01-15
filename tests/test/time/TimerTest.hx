package time;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.time.Timer;

class TimerTest 
{	
	@AsyncTest
	public function simple(asyncFactory:AsyncFactory):Void
	{
		var handler:Void->Void = asyncFactory.createHandler(this, empty, 30);
		new Timer(20).start().add(handler);
	}
	
	@AsyncTest
	public function tick(asyncFactory:AsyncFactory):Void
	{
		var count = 0;
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.areEqual(count, 1), 50);
		new massive.munit.util.Timer(30).run = handler;
		Timer.tick(10).add(function() count++ );
	}
	
	private function empty():Void null;
	
}