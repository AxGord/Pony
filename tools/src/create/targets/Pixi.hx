package create.targets;

class Pixi {

	public static function set(project:Project):Void {
		JS.set(project);
		project.download.addLib('pixijs');
		project.haxelib.addLib('pixijs', '4.5.5');
		project.uglify.libs.push(project.download.getLibFinal('pixijs'));
	}

}