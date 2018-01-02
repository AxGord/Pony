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

import massive.munit.Assert;
import pony.magic.StaticInit;

class StaticInitTest 
{
	//#if !flash //problem with __init__ in flash/munit 
	@Test
	public function test():Void
	{
		Assert.areEqual(SimpleStaticClass.someField, 'Hello');
		Assert.areEqual(SimpleStaticClass.fromGet, 'world');
		
		Assert.areEqual(SimpleStaticClass2.someField, 'Hi');
		Assert.areEqual(SimpleStaticClass2.fromGet, 'man');
		
		Assert.areEqual(SimpleStaticClass3.someField, 'wee');
	}
	//#end
}

class SimpleStaticClass implements StaticInit {
	
	public static var someField:String = 'Hello';
	public static var emptyField:String;
	public static var fromGet:String = getStr('wo');
	
	private static function getStr(s:String):String return s + 'rld';
	
}

class SimpleStaticClass2 implements StaticInit {
	
	public static var someField:String = 'Hi';
	public static var emptyField:String;
	public static var fromGet:String = getStr('m');
	
	private static function getStr(s:String):String return s + 'an';
	
}
class SimpleStaticClass3 implements StaticInit {
	
	public static var someField:String = 'wee';
	
}