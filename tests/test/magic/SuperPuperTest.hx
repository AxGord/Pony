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
package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.SuperPuper;

class SuperPuperTest 
{
	@Test
	public function testExample():Void
	{
		var obj = new SecondChildClass();
		var result = null;
		obj.test('Hello', function(r) result = r);
		Assert.areEqual(result, 'Hello world!');
	}
}


@:final class SecondChildClass extends ChildClass {
	
	override public function test(arg:String, cb:String->Void):Void {
		addSpace(arg, function(s) super.test(s, cb));
	}
	
	private function addSpace(arg:String, cb:String->Void):Void cb(arg+' ');
	
}

class ChildClass extends BaseClass {
	
	override public function test(arg:String, cb:String->Void):Void {
		addWorld(arg, function(s) super.test(s, cb));
	}
	
	private function addWorld(arg:String, cb:String->Void):Void cb(arg + 'world');
	
}

class BaseClass implements SuperPuper {
	
	public function new() {
		
	}
	
	@:puper public function test(arg:String, cb:String->Void):Void {
		cb(arg+'!');
	}
}