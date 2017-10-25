package create.targets;

class Node {

	public static function set(project:Project):Void {
		Server.set(project);
		project.haxelib.active = true;
		project.haxelib.addLib('pony', Utils.ponyVersion);
		project.haxelib.addLib('hxnodejs', '4.0.9');
		project.build.active = true;
		project.build.target = types.HaxeTargets.JS;
		project.build.esVersion = 6;
		project.setRun('node');
		project.uglify.active = true;
	}

}