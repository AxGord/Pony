package create.targets;

/**
 * CC
 * @author AxGord <axgord@gmail.com>
 */
class CC {

	public static function set(project:Project, ?second:Bool):Void {
		project.server.active = true;
		project.server.http = false;
		project.server.httpPort = 7456;
		project.server.haxe = true;
		project.haxelib.active = true;
		project.haxelib.addLib('pony', Utils.ponyHaxelibVersion);
		project.haxelib.addLib('hcc', '2.0.1');

		var build = !second ? project.build : project.secondbuild;
		var uglify = !second ? project.uglify : project.seconduglify;

		build.active = true;
		build.target = types.HaxeTargets.JS;
		build.outputPath = 'assets/Script/';
		uglify.active = true;
		uglify.mapOffset = 12;
		uglify.c = false;
		uglify.m = false;
		project.url.active = true;
		project.url.list.push('http://localhost:' + project.server.httpPort + '/update-db');
	}

}