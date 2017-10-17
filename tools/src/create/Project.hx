package create;

import create.section.*;

class Project {

	public var server(default, null):Server = new Server();
	public var download(default, null):Download = new Download();
	public var haxelib(default, null):Haxelib = new Haxelib();
	public var build(default, null):Build = new Build();

	public var name:String;

	public function new(name:String) this.name = name;

	public function result():Xml {
		var root = Xml.createElement('project');
		if (name != null) root.set('name', name);
		if (server.active) root.addChild(server.result());
		if (download.active) root.addChild(download.result());
		if (haxelib.active) root.addChild(haxelib.result());
		if (build.active) root.addChild(build.result());
		if (root.firstChild() == null) {
			root.addChild(Xml.createComment('Put configuration here'));
		}
		return root;
	}

	public function getMain():String {
		return build.active ? build.getMainhx() : null; 
	}

	public function getCps():Array<String> {
		return [];
	}

	public function getLibs():Map<String, String> {
		var map = new Map<String, String>();
		if (haxelib.active) {
			for (lib in haxelib.libs.keys()) map[lib] = haxelib.libs[lib];
		}
		if (build.active) {
			for (lib in build.libs.keys()) map[lib] = build.libs[lib];
		}
		return map;
	}

}