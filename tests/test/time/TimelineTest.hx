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
		
		DeltaTime.testRun('8s');
		Assert.areEqual(lastStep, 2);
		t.play();
		DeltaTime.testRun('8s');
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