package time;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.time.DeltaTime;
import pony.time.Timeline;

class TimelineTest 
{	
	@Test
	public function testPlay():Void
	{
		var t = new Timeline(['2s', '5s', '12s']);
		var lastStep:Int = 0;
		t.onStep << function(step:Int) lastStep = step;
		t.play();
		DeltaTime.testRun('1s');
		Assert.areEqual(lastStep, 0);
		DeltaTime.testRun('3s');
		Assert.areEqual(lastStep, 1);
		DeltaTime.testRun('4s');
		Assert.areEqual(lastStep, 2);
		DeltaTime.testRun('5s');
		Assert.areEqual(lastStep, 3);
		DeltaTime.testRun('25s');
		Assert.areEqual(lastStep, 3);
	}
	
	@Test
	public function testPlayWithPause():Void
	{
		var t = new Timeline(['2s', '5s', '12s'], true);
		var lastStep:Int = 0;
		t.onStep << function(step:Int) lastStep = step;
		t.play();
		DeltaTime.testRun('1s');
		Assert.areEqual(lastStep, 0);
		DeltaTime.testRun('3s');
		Assert.areEqual(lastStep, 1);
		DeltaTime.testRun('4s');
		Assert.areEqual(lastStep, 1);
		t.play();
		DeltaTime.testRun('4s');
		Assert.areEqual(lastStep, 2);
		
		DeltaTime.testRun('5s');
		Assert.areEqual(lastStep, 2);
		t.play();
		DeltaTime.testRun('5s');
		Assert.areEqual(lastStep, 3);
		
		DeltaTime.testRun('25s');
		Assert.areEqual(lastStep, 3);
	}
	
	@Test
	public function testPause():Void {
		var t = new Timeline(['2s', '5s', '12s'], true);
		var lastStep:Int = 0;
		t.onStep << function(step:Int) lastStep = step;
		t.play();
		DeltaTime.testRun('1s');
		Assert.areEqual(lastStep, 0);
		t.pause();
		DeltaTime.testRun('10s');
		Assert.areEqual(lastStep, 0);
		t.play();
		DeltaTime.testRun('3s');
		Assert.areEqual(lastStep, 1);
	}
	
	@Test
	public function testPlayTo():Void {
		var t = new Timeline(['2s', '5s', '12s'], true);
		var lastStep:Int = 0;
		t.onStep << function(step:Int) lastStep = step;
		t.playTo(2);
		DeltaTime.testRun('1s');
		Assert.areEqual(lastStep, 0);
		DeltaTime.testRun('3s');
		Assert.areEqual(lastStep, 1);
		DeltaTime.testRun('4s');
		Assert.areEqual(lastStep, 2);
		DeltaTime.testRun('5s');
		Assert.areEqual(lastStep, 2);
		DeltaTime.testRun('25s');
		Assert.areEqual(lastStep, 2);
	}
	
}