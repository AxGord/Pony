/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.PosInfos;

/**
 * Use this only for tests. Help for async code tests.
 * @author AxGord
 */

class MUnitHelper
{
	private var end:Bool;
	private var __handler:Dynamic;
	private var __handlerF:Dynamic;
	
	@BeforeClass
	public function setEnd():Void
	{
		end = false;
	}
	
	private function fail(?info:PosInfos):Dynamic->Void {
		return function(r:String) return Assert.fail(r, info);
	}
	
	private function eq(s:Dynamic, ?info:PosInfos):Dynamic->Void {
		return function(r:Dynamic) {
			end = true;
			Assert.areEqual(s, r, info);
		};
	}
	
	private function eqA(s:Dynamic, ?info:PosInfos):Dynamic->Void {
		return function(r:Dynamic) __handler(true, r, s);
	}
	
	private function failA(?info:PosInfos):Dynamic->Void {
		return function(r:Dynamic) __handler(false, r);
	}
		
	private function createHandler(factory:AsyncFactory, timeout:Int=10000, ?info:PosInfos, next:Void->Void):Void {
		__handler = factory.createHandler(this, function(ok:Bool, r:Dynamic, v:Dynamic) {
			if (ok)
				Assert.areEqual(v, r);
			else
				Assert.fail(r);
		}, timeout, info);
		Timer.delay(next, 1);
	}
	
}