/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
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
		DeltaTime.fixedValue = 1;
		for (_ in 0...5) {
			DeltaTime.fixedDispatch();
		}
		Assert.areEqual(r, 1);
		
	}
	
}