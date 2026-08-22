package magic.di;

import pony.magic.DI;

class Producer implements DI {

	@:share public var shared: Shared = new Shared();

	public function new() {}

}
