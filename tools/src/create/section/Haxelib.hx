package create.section;

typedef Lib = {
	name: String,
	?version: String,
	?mute: Bool,
	?git: String,
	?commit: String,
	?y: Bool,
	?parent: String,
	?path: String
}

/**
 * Haxelib
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Haxelib extends Section {

	public var libs(default, null): Array<Lib> = [];
	public var mute: Bool = false;

	public function new() super('haxelib');

	public function addLib(lib: Lib): Void libs.push(lib);

	override public function result(): Xml {
		init();
		for (lib in libs) {
			var n: Xml = add('lib', lib.version == null ? lib.name : '${lib.name} ${lib.version}');
			if (lib.parent != null) n.set('parent', lib.parent);
			if (lib.path != null) n.set('path', lib.path);
			if (lib.git != null) n.set('git', lib.git);
			if (lib.commit != null) n.set('commit', lib.commit);
			if (lib.y == true) n.set('y', 'true');
			if (mute || lib.mute == true) n.set('mute', 'true');
		}
		return xml;
	}

}