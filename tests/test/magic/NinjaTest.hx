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

import magic.NinjaTest.NinjaClass;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.Ninja;

class NinjaTest 
{
	@Test
	public function test():Void
	{
		var n = new NinjaClass(1);
		Assert.areEqual(n._number, 0);
		Assert.areEqual(n.def, 1);
		var n = n.number(5);
		Assert.areEqual(n.def, 1);
		Assert.areEqual(n._number, 5);
		var n = n.text('hello');
		Assert.areEqual(n.def, 1);
		Assert.areEqual(n._number, 5);
		Assert.areEqual(n._text, 'hello');
	}
}

class NinjaClass implements Ninja {
	
	public var _number:Int = 0;
	public var _text:String;
	public var def:Int;
	
	public function new(def) this.def = def;

	@:n public function number(n:Int):NinjaClass {
		_number = n;
	}
	
	@:n public function text(s:String):NinjaClass _text = s;
	
	public function ninjaCreate():NinjaClass return new NinjaClass(1);
	
}