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

import magic.DeclaratorTest.DeclaratorTestHelper;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.Declarator;

class DeclaratorTest 
{	
	@Test
	public function staticInit():Void
	{
		Assert.areEqual(DeclaratorTestHelper.b, DeclaratorTestHelper.a);
		Assert.areEqual(DeclaratorTestHelper.b, 'hello');
	}
	
	@Test
	public function const():Void {
		var d = new DeclaratorTestHelper(5, 6);
		Assert.areEqual(d.sum(), 11);
		
		var d = new DeclaratorTestHelper(5);
		Assert.areEqual(d.sum(), 8);
	}
	
	@Test
	public function subEmpty():Void {
		var d = new DeclaratorTestHelperSub(3, 5, 6);
		Assert.areEqual(d.sum(), 33);
		
		var d = new DeclaratorTestHelperSub(2, 5);
		Assert.areEqual(d.sum(), 14);
	}
	
}

class DeclaratorTestHelper implements Declarator {
	static public var a:String = 'hello';
	static public var b:String;
	static public function __init__():Void b = a;
	
	@:arg private var i:Int;
	@:arg private var j:Int = 3;
	
	public function sum():Int return i + j;
	
}


class DeclaratorTestHelperSub extends DeclaratorTestHelper {
	@:arg private var v:Int;
	
	public function new(i:Int, j:Int=2) {
		super(i, j);
	}
	
	override public function sum():Int {
		return super.sum() * v;
	}
}
