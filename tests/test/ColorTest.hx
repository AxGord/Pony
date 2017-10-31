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
import pony.color.Color;
import pony.color.UColor;

class ColorTest 
{
	@Test
	public function split():Void
	{
		var c:UColor = 0xFF559922;
		Assert.areEqual(c.a, 0xFF);
		Assert.areEqual(c.r, 0x55);
		Assert.areEqual(c.g, 0x99);
		Assert.areEqual(c.b, 0x22);
		
		Assert.areEqual(c.af, 1);
		Assert.areEqual(c.gf, 0.6);
	}
	
	@Test
	public function parse():Void {
		var c:UColor = '#3388CC';
		Assert.areEqual(c, 0x3388CC);
	}
	
	@Test
	public function rgb():Void {
		var c:UColor = 'rgb(255, 0, 155)';
		Assert.areEqual(c, 0xFF009B);
	}
	
	@Test
	public function argb():Void {
		var c:UColor = 'argb(120, 255, 0, 155)';
		Assert.areEqual(c, 0x78FF009B);
	}
	
	@Test
	public function addNegative():Void {
		var a:Color = new Color(0, 255, -67, 0);
		var b:Color = new Color(0, 66, 66, 66);
		var c:Color = b + a;
		Assert.areEqual(c.a, 0);
		Assert.areEqual(c.r, 255);
		Assert.areEqual(c.g, -1);
		Assert.areEqual(c.b, 66);
		Assert.isTrue(c == new UColor(0xFF0042));
	}
}