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

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.math.Balance;
import pony.Tools;
import pony.math.MathTools;

class BalanceTest 
{	
	
	private var b:Balance;
	
	@Before
	public function setup():Void
	{
		b = [0.04, 0.08, 0.12];
		b.calc(3);
		//trace(b);
	}
	
	@Test
	public function add():Void
	{
		b[3] += 0.1;
		checkPositive();
		Assert.areEqual(b[0]+b[1], 0.07);
		Assert.areEqual(b[2], 0.07);
	}
	
	@Test
	public function sub():Void
	{
		b[3] -= 0.1;
		checkPositive();
		Assert.isTrue(MathTools.inRange(b[0]+b[1], 0.16, 0.18));
		Assert.isTrue(MathTools.inRange(b[2], 0.16, 0.18));
	}
	
	private function checkPositive():Void {
		for (e in b) Assert.isTrue(e >= 0);
	}
	
}