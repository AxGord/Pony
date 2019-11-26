package create.targets;

/**
 * Heaps
 * @author AxGord <axgord@gmail.com>
 */
class Heaps {

	public static function set(project: Project, ?second: Bool): Void {
		JS.set(project, second);
		project.config.active = true;
		project.config.options['width'] = '1280';
		project.config.options['height'] = '1024';
		project.config.options['background'] = '#1A1A1A';
		project.config.options['baseUrl'] = 'assets/';
		project.haxelib.addLib('heaps', '1.7.0');
	}

}