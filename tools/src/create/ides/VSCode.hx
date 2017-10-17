package create.ides;

import sys.FileSystem;

class VSCode {

	public static function create():Void {
		if (!FileSystem.exists('.vscode')) {
			FileSystem.createDirectory('.vscode');
			var data = {
				version: '2.0.0',
				tasks: [{
					taskName: 'pony build debug',
					type: 'shell',
					command: 'pony build debug',
					problemMatcher: ["$haxe"],
					group: {
						kind: 'build',
						isDefault: true
					}
				}]
			};
			Utils.saveJson('.vscode/tasks.json', data);
		}
	}

}