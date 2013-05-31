package ;

import haxe.macro.Expr;
import pony.macro.Tools;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
using pony.Function;

class FunctionTest 
{
	
	@Test
	public function arg0():Void
	{
		var f:Function = function() return 'qwe';
		Assert.areEqual(f.call(), 'qwe');
		Assert.areEqual(f.count(), 0);
		f.unuse();
	}
	
	@Test
	public function arg1():Void
	{
		var f:Function = function(s:String) return s;
		Assert.areEqual(f.call('asd'), 'asd');
		Assert.areEqual(f.count(), 1);
		f.unuse();
	}
	
	@Test
	public function arg3():Void
	{
		var f:Function = function(a:String, b:String, c:String) return a + b + c;
		Assert.areEqual(f.count(), 3);
		Assert.areEqual(f.call('a','w','d'), 'awd');
		f.unuse();
	}
	
	@Test
	public function lamda():Void
	{
		var b:Bool = false;
		var f:Function = function(f:Bool) b = f;
		Assert.isFalse(b);
		f.call(true);
		Assert.isTrue(b);
		f.call(false);
		Assert.isFalse(b);
		Assert.areEqual(f.count(), 1);
		f.unuse();
	}
	
	@Test
	public function multy():Void {
		Assert.areEqual(cll(1, 2, 3, 7, 8), 5);
		Assert.areEqual(cll(), 0);
	}
	
	macro public function cll(b:Array<Expr>):Expr return Tools.argsArray(macro _cll, b);
	public function _cll(a:Array<Int>):Int {
		return a.length;
	}
	
}