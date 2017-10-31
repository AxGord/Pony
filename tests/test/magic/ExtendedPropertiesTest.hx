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
package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.ExtendedProperties;

class ExtendedPropertiesTest
{

	var o:ExtendedPropertiesTestHelper;
	
	@Before
	public function setup() {
		o = new ExtendedPropertiesTestHelper();
	}
	
	@Test
	public function hidden():Void
	{
		Assert.areEqual(o.p, 7);
		Assert.areEqual(o.tget(), 4);
		Assert.areEqual(o.vget(), 3);
		Assert.areEqual(o.tvget(), 4);
		Assert.areEqual(o.dget(), 12);
		Assert.areEqual(o.fget(), 55);
		Assert.areEqual(o.ffget(), 25);
		Assert.areEqual(o.g, 4);
	}
	
	@Test
	public function prop():Void {
		Assert.areEqual(o.value, 3);
	}
}

class ExtendedPropertiesTestHelper implements ExtendedProperties {
	
	@prop public var g:Int = p;
	
	public var p(_, never):Int;
	
	public function get_p():Int return p + 3;
	
	public function new() {
		p = 4;
	}
	
	public function tget() return this.p;
	
	public function vget(p:Int = 3) return p;
	public function tvget(p:Int = 3) return this.p;
	public function dget() {
		var p = 12;
		return p;
	}
	
	public function fget() {
		function p(v) return v;
		return p(55);
	}
	
	public function ffget() {
		function f(p) return p;
		return f(25);
	}
	
	@prop inline public function value():Int return 3;
	
}