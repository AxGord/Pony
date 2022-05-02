package create;

import create.section.*;

/**
 * Project
 * @author AxGord <axgord@gmail.com>
 */
class Project {

	public var run(default, null):Run = new Run();
	public var server(default, null):Server = new Server();
	public var config(default, null):Config = new Config();
	public var download(default, null):Download = new Download();
	public var haxelib(default, null):Haxelib = new Haxelib();
	public var build(default, null):Build = new Build();
	public var secondbuild(default, null):Build = new Build();
	public var thirdbuild(default, null):Build = new Build();
	public var fourthbuild(default, null):Build = new Build();
	public var uglify(default, null):Uglify = new Uglify();
	public var seconduglify(default, null):Uglify = new Uglify();
	public var npm(default, null):Npm = new Npm();
	public var url(default, null):Url = new Url();
	public var cordova(default, null):Cordova = new Cordova();
	public var electron(default, null):Electron = new Electron();
	public var hashlink(default, null):Hashlink = new Hashlink();

	public var name:String;
	public var rname(get, never):String;

	public function new(name:String) this.name = name;

	public function result():Xml {
		var root = Xml.createElement('project');
		if (name != null) root.set('name', name);

		if (!config.active && build.active) {
			var cfg = Xml.createElement('config');
			cfg.addChild(Xml.createComment('Put configuration here'));
			root.addChild(cfg);
		}

		if (run.active) root.addChild(run.result());
		if (electron.active) root.addChild(electron.result());
		if (server.active) root.addChild(server.result());
		if (cordova.active) {
			cordova.title = name;
			root.addChild(cordova.result());
		}
		if (config.active) {
			if (build.active) config.dep = config.dep.concat(build.getDep());
			root.addChild(config.result());
		}
		if (download.active) root.addChild(download.result());
		if (haxelib.active) root.addChild(haxelib.result());
		if (npm.active) root.addChild(npm.result());
		if (hashlink.active) {
			if (hashlink.needClean()) root.addChild(hashlink.getClean());
			root.addChild(hashlink.result());
		}

		addBuilds(root);

		if (url.active) root.addChild(url.result());

		if (root.firstChild() == null) {
			root.addChild(Xml.createComment('Put configuration here'));
		}
		return root;
	}

	public function addBuilds(root: Xml): Void {
		if (build.active) {
			root.addChild(build.result());
			if (uglify.active) {
				uglify.outputPath = build.outputPath;
				uglify.outputFile = build.getOutputFile();
				root.addChild(uglify.result());
			}
		}
		if (secondbuild.active) {
			if (build.active && build.appNode != null && secondbuild.appNode != null)
				secondbuild.addTo(build);
			else
				root.addChild(secondbuild.result());
			if (seconduglify.active) {
				seconduglify.outputPath = secondbuild.outputPath;
				seconduglify.outputFile = secondbuild.getOutputFile();
				if (uglify.active && uglify.appNode != null && seconduglify.appNode != null)
					seconduglify.addTo(uglify);
				else
					root.addChild(seconduglify.result());
			}
		}
		if (thirdbuild.active) {
			if (build.active && build.appNode != null && thirdbuild.appNode != null)
				thirdbuild.addTo(build);
			else if (secondbuild.active && secondbuild.appNode != null && thirdbuild.appNode != null)
				thirdbuild.addTo(secondbuild);
			else
				root.addChild(thirdbuild.result());
		}
		if (fourthbuild.active) {
			if (build.active && build.appNode != null && fourthbuild.appNode != null)
				fourthbuild.addTo(build);
			else if (secondbuild.active && secondbuild.appNode != null && fourthbuild.appNode != null)
				fourthbuild.addTo(secondbuild);
			else if (thirdbuild.active && thirdbuild.appNode != null && fourthbuild.appNode != null)
				fourthbuild.addTo(thirdbuild);
			else
				root.addChild(thirdbuild.result());
		}
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
			for (lib in haxelib.libs) map[lib.name] = lib.version;
		}
		if (build.active) {
			for (lib in build.libs.keys()) map[lib] = build.libs[lib];
		}
		return map;
	}

	public function setRun(cmd:String):Void {
		run.active = true;
		run.path = build.outputPath;
		run.command = cmd + ' ' + build.outputFile;
	}

	private function get_rname():String return name == null ? 'App' : name;

}