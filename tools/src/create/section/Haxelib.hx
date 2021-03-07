package create.section;

import pony.text.XmlTools;

/**
 * Haxelib
 * @author AxGord <axgord@gmail.com>
 */
class Haxelib extends Section {

	public var libs(default, null): Map<String, String> = new Map<String, String>();
	public var mute: Bool = false;

	public function new()
		super('haxelib');

	public function addLib(name: String, ?version: String): Void {
		libs[name] = version;
	}

	public function result(): Xml {
		init();
		for (name in libs.keys()) {
			var v: String = libs[name];
			var n: Xml = add('lib', v == null ? name : '$name $v');
			if (mute) n.set('mute', 'true');
		}
		return xml;
	}

}