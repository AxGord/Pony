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
import pony.Stream;

class StreamTest 
{
	@Test
	public function afterTake():Void
	{
		var a = [false, false, false];
		var e = false;
		var s = new Stream<Int>();
		s.take(function(d:Int) a[d] = true, function()e=true);
		s.dataListener(0);
		s.dataListener(1);
		Assert.isTrue(a[0]);
		Assert.isTrue(a[1]);
		Assert.isFalse(a[2]);
		s.dataListener(2);
		Assert.isTrue(a[2]);
		s.endListener();
		Assert.isTrue(e);
	}
	
	@Test
	public function beforeTake():Void
	{
		var a = [false, false, false];
		var e = false;
		var s = new Stream<Int>();
		s.dataListener(0);
		s.dataListener(1);
		s.dataListener(2);
		s.endListener();
		s.take(function(d:Int) a[d] = true, function()e=true);
		Assert.isTrue(a[0]);
		Assert.isTrue(a[1]);
		Assert.isTrue(a[2]);
		Assert.isTrue(e);
	}
	@Test
	public function mapAfter():Void
	{
		var a = [false, false, false];
		var e = false;
		var s = new Stream<Int>();
		s.map(function(n) return n - 1).take(function(d:Int) a[d] = true, function() e=true);
		s.dataListener(1);
		s.dataListener(2);
		Assert.isTrue(a[0]);
		Assert.isTrue(a[1]);
		Assert.isFalse(a[2]);
		s.dataListener(3);
		Assert.isTrue(a[2]);
		s.endListener();
		Assert.isTrue(e);
	}
}