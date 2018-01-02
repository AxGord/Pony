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
package time ;

import massive.munit.Assert.*;
import pony.time.Time;
import pony.time.TimeInterval;

class TimeTest 
{
	@Test
	public function simple():Void
	{
		var time:Time = '1:00';
		areEqual((time:Int), 60000);
	}
	
	@Test
	public function add():Void {
		var t1:Time = '1:40';
		var t2:Time = '30';
		areEqual(t1 + t2, ('2:10':Time));
	}
	
	@Test
	public function extr():Void {
		var d:Time = '-90';
		areEqual(d, ('-01:30':Time));
	}
	
	@Test
	public function named():Void {
		var t:Time = '2m 30s';
		areEqual(t, ('2:30':Time));
	}
	
	@Test
	public function neg():Void {
		var n:Time = -1000;
		areEqual((n:String), '-00:00:01');
	}
	
	@Test
	public function timeInterval():Void {
		var t:TimeInterval = 500...3000;
		areEqual(t.toString(), '00:00:00.500 ... 00:00:03');
		var t:TimeInterval = '27min ... 30min';
		areEqual(t.toString(), '00:27:00 ... 00:30:00');
	}
	
	@Test
	public function timeInInterval():Void {
		var t:TimeInterval = '27min ... 30min';
		isTrue(t.check('27:30'));
		isFalse(t.check('01:30'));
		var t:TimeInterval = '3min';
		isTrue(t.check('01:30'));
		isFalse(t.check('10:35'));
	}
}