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

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.xml.Fast;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
using pony.Tools;
using pony.text.TextTools;
using pony.math.MathTools;

enum A {
 E2(t:Int);
 E3(o:Dynamic);
}

enum B { E; }

class N {
  
}

interface IA {}
interface IB {}


class ToolsTest 
{
	
	@Test
	public function explode():Void
	{
		Assert.isTrue('1-2 3 - 4'.explode(['-', ' ']).equal(['1', '2', '3', '4']));
	}
	
	@Test
	public function mask():Void {
		var number:Float = 54.7;
		Assert.areEqual(number.toFixed('   ,00'), ' 54,70');
	}
	
	@Test
	public function includeFile():Void {
		Assert.areEqual(TextTools.includeFile('test.txt'), 'Hello world!');
	}
	
	@Test
	public function equal():Void {
		Assert.isFalse(2.equal(3));
		Assert.isFalse(Tools.equal(null, "a"));
		Assert.isFalse("a".equal(null));
		Assert.isFalse(true.equal(false));
		Assert.isTrue(false.equal(false));
		Assert.isFalse(({}).equal(false));
		Assert.isTrue([1, 2].equal([1, 2]));
		Assert.isFalse(Date.now().equal(false));
		//Assert.isFalse(Tools.equal(Date.now, false));
		//Assert.isTrue(Date.now.equal(Date.now));
		Assert.isFalse(Tools.equal(function() {}, false));
		Assert.isTrue(E2(1).equal(E2(1)));
		Assert.isTrue(E3({b:1}).equal(E3({b:1}), 5));
		Assert.isFalse(E3({b:1}).equal(E2(0), 5));
		
		Assert.isTrue(Tools.equal({a:1, b:{c:1}, d:{}}, {a:1, b:{c:1}, d:{}}, 5));
		Assert.isFalse(Tools.equal({a:1, b:{c:1}, d:{}}, {a:1, b:{c:1}, d:{e:3}}, 5));
		
		Assert.isTrue(Tools.equal([[[1]]], [[[1]]], 5));
		
		Assert.isFalse(Tools.equal([1], [1, 2]));
		
		var o = {b:{}};
		o.b = o;
		var p = {b:{}};
		p.b = p;
		Assert.isFalse(Tools.equal(o, p, 5)); // tada
		
		Assert.isFalse(Tools.equal(ToolsTest, N));
		Assert.isFalse(Tools.equal(IA, IB));
		Assert.isFalse(Tools.equal(A, B));
	}
	
	@Test
	public function culture():Void {
		var v = 5.;
		var target = 20.;
		v = v.cultureTarget(target, 4.3);
		v = v.cultureTarget(target, 4.3);
		v = v.cultureTarget(target, 4.3);
		v = v.cultureTarget(target, 4.3);
		v = v.cultureTarget(target, 4.3);
		v = v.cultureTarget(target, 4.3);
		Assert.areEqual(v, target);
	}
	
	@Test
	public function nore():Void {
		Assert.isTrue([].nore());
		Assert.isTrue(''.nore());
		Assert.isFalse([1].nore());
		Assert.isFalse('1'.nore());
	}
	
	@Test
	public function or():Void {
		var v:String = null;
		Assert.areEqual(v.or('q'), 'q');
		v = 'w';
		Assert.areEqual(v.or('q'), 'w');
	}
	
	@Test
	public function with ():Void {
		var o = { x:4, y: 7 };
		o.with(x = 6, y = 8);
		Assert.areEqual(o.x, 6);
		Assert.areEqual(o.y, 8);
	}
	
	@Test
	public function cut():Void 
	{
		var b1:BytesOutput = new BytesOutput();	
		b1.writeByte(1);
		b1.writeByte(0);
		b1.writeByte(1);
		//b1.writeByte(34);
		//b1.writeByte(12);
		
		var b2:BytesInput = new BytesInput(b1.getBytes());
		
		var b3 = Tools.cut(b2);
		var bi = b3.bytesInputIterator();
		for (b in b2.bytesInputIterator()) Assert.areEqual(b, bi.next());
		
	}
	
	@Test
	public function setFields():Void {
		var a = {
			a: 5,
			b: {
				c: 7,
				d: 8
			}
		};
		
		var b:Dynamic = {
			b: {
				c: 3
			}
		};
		
		var c:Dynamic = {
			a: 5,
			b: {
				c: 3,
				d: 8
			}
		};
		
		a.setFields(b);
		Assert.isTrue(a.equal(c, 2));
	}
	
	@Test
	public function parsePrefixObjects():Void {
		var obj = {
			'a_b_c': '1',
			'a_f_c': '2',
			'f': '3'
		};
		Assert.isTrue(obj.parsePrefixObjects().equal({
			a: { 
				b: { c: '1' },
				f: { c: '2' }
			},
			f: '3'
		}, 3));
	}
	
	@Test
	public function convertObject():Void {
		var a = {
			a: '1',
			b: {c:'3'}
		};
		var b = a.convertObject(function(a:String) return Std.parseInt(a) );
		Assert.isTrue(b.equal({
			a: 1,
			b: {c:3}
		}, 2));
	}
	
	@Test
	public function writeReadStr():Void {
		var bo = new BytesOutput();
		bo.writeStr('hello world');
		var bi = new BytesInput(bo.getBytes());
		Assert.areEqual(bi.readStr(), 'hello world');
	}
	
	@Test
	public function swap():Void {
		Assert.isTrue([1, 2, 3, 4].swap(0, 3).equal([4, 2, 3, 1]));
		Assert.isTrue([1, 2, 3, 4].swap(0, 1).equal([2, 1, 3, 4]));
		Assert.isTrue([3, 4].swap(1, 0).equal([4,3]));
	}
	
	@Test
	public function own():Void {
		Assert.isTrue(OwnTest1.own(OwnTest1));
		Assert.isFalse(OwnTest1.own(OwnTest2));
		Assert.isTrue(OwnTest1.own(OwnTest3));
		Assert.isFalse(OwnTest3.own(OwnTest1));
	}
	
	@Test
	public function clone():Void {
		var a:Array<Dynamic> = ['sdas', {c:333}];
		var o = {a:123, b:a};
		var n = o.clone();
		Assert.areEqual(o.a, n.a);
		Assert.areEqual(o.b[0], n.b[0]);
		Assert.areEqual(o.b[1].c, n.b[1].c);
		//todo: Test enum
	}
	
}


private class OwnTest1 {
	
	
}

private class OwnTest2 {
	
}

private class OwnTest3 extends OwnTest1 {
	
}