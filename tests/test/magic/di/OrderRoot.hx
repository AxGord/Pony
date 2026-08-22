package magic.di;

import pony.magic.DI;

/** `db` needs `settings` but is declared before it — the graph, not the order, should decide. */
class OrderRoot implements DI {

	@:own public var db: Db = new Db();
	@:own public var settings: Settings = new Settings();

	public function new() Trace.add('OrderRoot');

}
