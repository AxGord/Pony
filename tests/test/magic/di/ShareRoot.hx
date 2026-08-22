package magic.di;

import pony.magic.DI;

class ShareRoot implements DI {

	@:own public var producer: Producer = new Producer();
	@:own public var sibling: Sibling = new Sibling();

	public function new() {}

}
