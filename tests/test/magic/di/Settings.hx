package magic.di;

import pony.magic.DI;

class Settings implements DI {

	public static inline final PATH: String = '/tmp';

	public final path: String = PATH;

	public function new() Trace.add('Settings');

	public function destroy(): Void Trace.add('~Settings');

}
