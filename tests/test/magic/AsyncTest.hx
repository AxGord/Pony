package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import pony.MUnitHelper;
import pony.magic.async.AsyncAuto;
import pony.magic.async.AsyncAutoAll;
import pony.magic.Declarator;

/**
 * ...
 * @author AxGord
 */

class AsyncTest extends MUnitHelper, implements AsyncAuto
{
	@Test
	public function simpleTest():Void {
		firstAsync('hello', eq('*>hello<*'), fail());
		Assert.isTrue(end);
	}
	
	@AsyncAuto @remove
	public function first(s:String):String {
		return ('*' + second(s) + '*');
	}
	
	@AsyncAuto @remove
	public function second(s:String):String {
		return '>' + s + '<';
	}
	
	@Test
	public function ninja():Void {
		ninjaGoAsync(eq('>123'), fail());
		Assert.isTrue(end);
	}
	
	@AsyncAuto @remove
	private function ninjaGo():String {
		/* Idea for parallel
		$={
			1;
			2;
			3;
		};*/
		var n:AsyncN = new AsyncN();
		return n.go('1').go('2').go('3').result();
	}
	
	@AsyncTest
	public function delay(f:AsyncFactory):Void {
		createHandler(f, 1000, function() delay2Async(eqA('^hi^'), failA()));
	}
	
	@AsyncAuto @remove
	private function delay2():String {
		return '^' + delay3() + '^';
	}
	
	private function delay3Async(ok:Dynamic->Void, error:Dynamic->Void):Void {
		Timer.delay(function() ok('hi'), 5);
	}
	
}

class AsyncN extends pony.Ninja<AsyncN, {s:String}>, implements Declarator, implements AsyncAuto {
	
	private static var defaultObj:{s:String} = {s:'>'};
	
	@AsyncAuto @remove
	public function go(s:String):AsyncN {
		return next({s: obj.s + s}, false);
	}
	
	@AsyncAuto @remove
	public function result():String {
		return obj.s;
	}
	
}