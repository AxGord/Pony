package create.targets;

import pony.fs.Dir;
import pony.text.TextTools;

/**
 * Cordova
 * @author AxGord <axgord@gmail.com>
 */
class Cordova {

	private static inline var CORDOVA:String = 'cordova';
	private static inline var DSS:String = '.DS_Store';
	private static inline var DRW:String = 'drawable-';

	public static function set(project:Project):Void {
		Pixi.set(project);
		project.cordova.active = true;
		project.build.outputPath = 'www/';
		project.server.httpPath = 'www/';

		var c = ('.':Dir).content();
		if (c.length == 1 && c[0].name == DSS) {
			Sys.println('Remove $DSS');
			c[0].delete(); // Can't create cordova if dir have .DS_Store
		}

		if (project.name == null) {
			Utils.command(CORDOVA, ['create', '.', 'org.apache.cordova.pony.App', 'App']);
		} else {
			var cl:String = TextTools.bigFirst(project.name);
			Utils.command(CORDOVA, ['create', '.', 'org.apache.cordova.pony.$cl', cl]);
		}

		Sys.println('Clean res/');
		var screenDir:Dir = 'res/screen/';
		screenDir.deleteContent();
		screenDir.delete();
		var iconDir:Dir = 'res/icon/';
		iconDir.deleteContent();

		//todo: pony prepare for add platforms
		Utils.command(CORDOVA, ['platform', 'add', 'android']);
		var resPath:Dir = 'platforms/android/app/src/main/res/';
		for (dir in resPath.dirs()) if (dir.name.substr(0, DRW.length) == DRW) dir.delete();
		Utils.command(CORDOVA, ['platform', 'add', 'ios']);
		(project.build.outputPath:Dir).deleteContent();
	}

}