package math;

import massive.munit.Assert;
import pony.math.Liker;
import pony.time.DeltaTime;

class LikerTest 
{
	var instance:Liker; 
	
	@BeforeClass
	public function beforeClass():Void
	{
		instance = new Liker([
			[0.2, 0.5, 0.1],
			[0.2, 0.4, 0.1]
		]);
	}
	
	@Test
	public function likek():Void {
		Assert.areEqual(instance.likek([0.2, 0.4, 0.1], [0.2, 0.4, 0.1]), 3);
		Assert.areEqual(instance.likek([0.2, 10.4, 0.1], [0.2, 0.4, 0.1]), 0);
	}
	
	@Test
	public function test():Void
	{
		Assert.areEqual(instance.like([0.2, 0.42, 0.1]), 1);
		Assert.areEqual(instance.like([0.2, 0.47, 0.1]), 0);
		Assert.areEqual(instance.like([2.2, 0.47, 0.1]), -1);
	}
	
	@Test
	public function async():Void {
		var r:Int = -2;
		instance.likeAsync([0.2, 0.42, 0.1], function(id:Int) r = id);
		Assert.areEqual(r, -2);
		for (_ in 0...5) DeltaTime.fixedUpdate.dispatch(1);
		Assert.areEqual(r, 1);
		
	}
	
}