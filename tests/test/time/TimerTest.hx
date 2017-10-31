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
		t.complete << handler;
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
		t.complete << function() c++;
		t.start();
		new massive.munit.util.Timer(1500).run = handler;
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