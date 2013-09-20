package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.DeltaTime;
import pony.Loader;


class LoaderTest 
{
	private var flag:Bool;
	private var loader:Loader;
	private var progress:Int;
	
	
	@Before
	public function setup():Void
	{
		flag = false;
		loader = new Loader();
		loader.total++;
		loader.complite.add(function() flag = true);
		loader.progress.add(function(v:Float) progress = Math.floor(v * 100));
		loader.init();
	}
	
	@Test
	public function basicLoad():Void
	{
		DeltaTime.testRun(1);
		Assert.isFalse(flag);
		Assert.areEqual(progress, 0);
		loader.complites++;
		DeltaTime.testRun(1);
		Assert.isTrue(flag);
		Assert.areEqual(progress, 100);
	}
	
	@Test
	public function loadTasks():Void
	{
		var b:Bool = false;
		loader.addAction(function() b = true);
		DeltaTime.testRun(1);
		Assert.areEqual(progress, 50);
		Assert.isTrue(b);
		Assert.isFalse(flag);
		loader.complites++;
		DeltaTime.testRun(1);
		Assert.isTrue(flag);
		Assert.areEqual(progress, 100);
	}
	
}