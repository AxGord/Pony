package ;

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
		Assert.isTrue('1-2 3 - 4'.explode(['-',' ']).equal(['1','2','3','4']));
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
	
}