package magic.di;

import pony.magic.DI;

class Root implements DI {

	@:own public var settings: Settings = new Settings();
	@:own public var db: Db = new Db();

	public function new() Trace.add('Root');

}
