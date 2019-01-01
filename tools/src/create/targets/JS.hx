package create.targets;

/**
 * JS
 * @author AxGord <axgord@gmail.com>
 */
class JS {

	public static function set(project:Project, ?second:Bool):Void {
		Server.set(project);
		project.server.haxe = true;
		project.download.active = true;
		//project.download.addLib('stacktrace');
		project.download.addLib('docready');
		project.haxelib.active = true;
		project.haxelib.addLib('pony', Utils.ponyHaxelibVersion);

		var build = !second ? project.build : project.secondbuild;
		var uglify = !second ? project.uglify : project.seconduglify;

		build.active = true;
		build.target = types.HaxeTargets.JS;
		uglify.active = true;
		//uglify.debugLibs.push(project.download.getLibFinal('stacktrace'));
		uglify.libs.push(project.download.getLibFinal('docready'));
	}

}