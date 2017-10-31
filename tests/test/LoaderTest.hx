/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.time.DeltaTime;
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
		loader.onComplete.add(function() flag = true);
		loader.onProgress.add(function(v:Float) progress = Math.floor(v * 100));
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