package create.ides;

import sys.FileSystem;

class VSCode {

	public static function create(ponycmd:String='build'):Void {
		if (!FileSystem.exists('.vscode')) {
			FileSystem.createDirectory('.vscode');
			var data = {
				version: '2.0.0',
				tasks: [{
					taskName: 'pony $ponycmd debug',
					type: 'shell',
					command: 'pony $ponycmd debug',
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