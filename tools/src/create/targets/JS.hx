package create.targets;

class JS {

	public static function set(project:Project):Void {
		Server.set(project);
		project.server.haxe = true;
		project.download.active = true;
		project.download.addLib('stacktrace');
		project.haxelib.active = true;
		project.haxelib.addLib('pony', Utils.ponyVersion);
		project.build.active = true;
		project.build.target = types.HaxeTargets.JS;
		project.uglify.active = true;
		project.uglify.debugLibs.push(project.download.getLibFinal('stacktrace'));
	}

}