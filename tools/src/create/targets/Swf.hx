package create.targets;

/**
 * Swf
 * @author AxGord <axgord@gmail.com>
 */
class Swf {

	public static function set(project: Project): Void {
		project.server.active = true;
		project.server.haxe = true;
		project.haxelib.active = true;
		project.haxelib.addLib('pony', Utils.ponyHaxelibVersion);
		project.build.active = true;
		project.build.target = types.HaxeTargets.Swf;
		project.build.fdb = true;
	}

}