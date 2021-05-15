package create.section;

import pony.text.XmlTools;

/**
 * Haxelib
 * @author AxGord <axgord@gmail.com>
 */
class Haxelib extends Section {

	public var libs(default, null): Map<String, String> = new Map<String, String>();
	public var mute: Bool = false;
	private var muted: Array<String> = [];

	public function new()
		super('haxelib');

	public function addLib(name: String, ?version: String, mute: Bool = false): Void {
		libs[name] = version;
		if (mute) muted.push(name);
	}

	override public function result(): Xml {
		init();
		for (name in libs.keys()) {
			var v: String = libs[name];
			var n: Xml = add('lib', v == null ? name : '$name $v');
			if (mute || muted.indexOf(name) != -1) n.set('mute', 'true');
		}
		return xml;
	}

}