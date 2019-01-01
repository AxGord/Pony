package create.targets;

/**
 * Pixi
 * @author AxGord <axgord@gmail.com>
 */
class Pixi {

	public static function set(project:Project, ?second:Bool):Void {
		JS.set(project, second);
		project.config.active = true;
		project.config.options['width'] = '1280';
		project.config.options['height'] = '1024';
		project.config.options['background'] = '#1A1A1A';
		project.download.addLib('pixijs');
		project.haxelib.addLib('pixijs', '4.7.1');
		var uglify = !second ? project.uglify : project.seconduglify;
		uglify.libs.push(project.download.getLibFinal('pixijs'));
	}

}