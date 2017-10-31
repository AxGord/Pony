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
package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Listener0;
import pony.events.Listener1;

enum L { A; B; C; }

class ListenerTest 
{
	
	private var tl:L = null;
	
	@Test
	public function empty():Void
	{
		var b:Bool = false;
		var l:Listener0 = function() b = true;
		l.call();
		Assert.isTrue(b);
	}
	
	@Test
	public function arg():Void
	{
		var b:Bool = false;
		var l:Listener1<Bool> = function(f:Bool) return !( b = f );
		Assert.isFalse(l.call(true));
		Assert.isTrue(b);
		Assert.isTrue(l.call(false));
		Assert.isFalse(b);
	}
	
	@Test
	public function enumTest():Void {
		var l:Listener1<L> = enumHandler;
		l.call(L.B);
		Assert.areEqual(tl, L.B);
	}
	
	private function enumHandler(l:L):Void {
		tl = l;
	}
	
}