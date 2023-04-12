package magic;

import massive.munit.Assert;

import pony.magic.HasAbstract;

class HasAbstractTest {

	@Test
	public function test(): Void {
		var x = new ChildClass();
		Assert.areEqual(x.intToString(12), 'foo');
		Assert.areEqual(x.common(), 'bar');

	}

}

#if (haxe_ver >= 4.2) abstract #end

class MyAbstractBaseClass implements HasAbstract {

	public function new() {}

	@:abstract public function intToString(i: Int): String;

	public function common(): String {
		return 'bar';
	}

}

private class ChildClass extends MyAbstractBaseClass {

	public function new() {
		super();
	}

	#if (haxe_ver < 4.2) override #end
	public function intToString(i: Int): String {
		return 'foo';
	}

}