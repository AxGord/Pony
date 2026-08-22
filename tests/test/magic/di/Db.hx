package magic.di;

import pony.magic.DI;

class Db implements DI {

	@:use public var settings: Settings;

	/** Read in the constructor on purpose: `@:use` is assigned before the body runs. */
	public final path: String;

	public function new() {
		path = settings.path;
		Trace.add('Db');
	}

	public function destroy(): Void Trace.add('~Db');

}
