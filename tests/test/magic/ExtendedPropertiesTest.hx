package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.ExtendedProperties;

class ExtendedPropertiesTest
{

	var o:ExtendedPropertiesTestHelper;
	
	@Before
	public function setup() {
		o = new ExtendedPropertiesTestHelper();
	}
	
	@Test
	public function hidden():Void
	{
		Assert.areEqual(o.p, 7);
		Assert.areEqual(o.tget(), 4);
		Assert.areEqual(o.vget(), 3);
		Assert.areEqual(o.tvget(), 4);
		Assert.areEqual(o.dget(), 12);
		Assert.areEqual(o.fget(), 55);
		Assert.areEqual(o.ffget(), 25);
		Assert.areEqual(o.g, 4);
	}
	
	@Test
	public function prop():Void {
		Assert.areEqual(o.value, 3);
	}
}

class ExtendedPropertiesTestHelper implements ExtendedProperties {
	
	@prop public var g:Int = p;
	
	public var p(_, never):Int;
	
	public function get_p():Int return p + 3;
	
	public function new() {
		p = 4;
	}
	
	public function tget() return this.p;
	
	public function vget(p:Int = 3) return p;
	public function tvget(p:Int = 3) return this.p;
	public function dget() {
		var p = 12;
		return p;
	}
	
	public function fget() {
		function p(v) return v;
		return p(55);
	}
	
	public function ffget() {
		function f(p) return p;
		return f(25);
	}
	
	@prop inline public function value():Int return 3;
	
}