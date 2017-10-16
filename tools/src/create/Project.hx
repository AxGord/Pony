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
		var content = Xml.createDocument();
		var root = Xml.createElement('project');
		if (name != null) root.set('name', name);
		if (server.active) root.addChild(server.result());
		if (download.active) root.addChild(download.result());
		if (haxelib.active) root.addChild(haxelib.result());
		if (build.active) root.addChild(build.result());
		if (root.firstChild() == null) {
			root.addChild(Xml.createComment('Put configuration here'));
		}
		content.addChild(root);
		return content;
	}

}