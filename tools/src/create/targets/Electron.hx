package create.targets;

import create.section.Config;

/**
 * Electron
 * @author AxGord <axgord@gmail.com>
 */
class Electron {

	public static function set(project:Project):Void {
		Node.set(project);
		project.build.main = 'Application';
		project.config.active = true;
		var defWindow:ConfigOptions = [
			'name' => 'default',
			'width' => '1280',
			'height' => '1024',
			'minWidth' => '640',
			'minHeight' => '512',
			'background' => '#1A1A1A'
		];
		var windows:ConfigOptions = [
			'default' => defWindow
		];
		project.config.options['window'] = windows;
		project.haxelib.addLib({name: 'electron', version: '19.0.4'});
		project.npm.active = true;
		project.npm.path = project.build.outputPath;
	}

}