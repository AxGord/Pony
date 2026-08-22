package magic.di;

import pony.magic.DI;

class Sibling implements DI {

	@:use public var shared: Shared;

	public function new() {}

}
