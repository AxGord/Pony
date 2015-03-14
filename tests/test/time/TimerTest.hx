package time;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.time.Timer;

class TimerTest 
{	
	
	@AsyncTest
	public function simple(asyncFactory:AsyncFactory):Void
	{
		var handler:Void->Void = asyncFactory.createHandler(this, empty, 1000);
		var t = new Timer(20);
		t.complite << handler;
		t.start();
	}
	
	@AsyncTest
	public function tick(asyncFactory:AsyncFactory):Void
	{
		var count = 0;
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.areEqual(count, 1), 1000);
		new massive.munit.util.Timer(30).run = handler;
		Timer.delay(10, function() count++ );
	}
	
	private function empty():Void null;
	
	@AsyncTest
	public function repeat(asyncFactory:AsyncFactory):Void {
		var c = 0;
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.areEqual(c, 6), 5500);
		var t = new Timer('3ms', 5);
		t.complite << function() c++;
		t.start();
		new massive.munit.util.Timer(400).run = handler;
	}
	
	/* Munit problem?
	@AsyncTest
	public function reset(asyncFactory:AsyncFactory):Void {
		var c = 0;
		var handler:Void->Void = asyncFactory.createHandler(this, function() Assert.areEqual(c, 2), 5500);
		var t = null;
		t = new Timer(15);
		trace('start');
		t.complite.add(function() {
			c++;
			if (c == 1) {
				trace('restart');
				t.restart();
			}
		} ).start();
		
		new massive.munit.util.Timer(400).run = handler;
	}
	*/
}