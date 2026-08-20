package create.section;

import types.*;

/**
 * Npm
 * @author AxGord <axgord@gmail.com>
 */
class Npm extends Section {

	public var path: String;

	public function new() super('npm');

	#if (haxe_ver < 4.2) override #end
	public function result(): Xml {
		init();
		if (path != null) set('path', path);
		return xml;
	}

}
