import sys.io.File;
import sys.io.Process;
import Config.*;

/**
 * UserpathInstall
 * @author AxGord <axgord@gmail.com>
 */
class UserpathInstall extends BaseInstall {

	private var installNodePath:Bool = true;
	private var installPonyPath:Bool = true;

	public function new() {
		installNodePath = questionState('nodepath') != InstallQuestion.No;
		installPonyPath = questionState('ponypath') != InstallQuestion.No;
		super('userpath', true, true);
	}

	override public function run():Void {
		switch OS {
			case Windows:
				if (installNodePath && Utils.nodeExists)
					windowsNodeUserpath();
				if (installPonyPath)
					windowsPonyUserpath();
				
			case Mac:
				var home = Sys.getEnv('HOME');
				writeProfileFiles([home + '/.bash_profile', home + '/.zshrc']);

			case Linux:
				var home = Sys.getEnv('HOME');
				var pfile = home + '/.profile';
				writeProfileFiles([pfile]);

		}
	}

	private inline function windowsNodeUserpath():Void {
		if (Sys.getEnv('NODE_PATH') == null) {
			var modulespath = Sys.getEnv('appdata') + PD + 'npm' + PD + 'node_modules';
			setx('NODE_PATH', modulespath);
		}
	}

	private inline function windowsPonyUserpath():Void {
		
		var envPath:String = Sys.getEnv(ENVKEY);
		
		if (envPath == null) {
		
			var user = Sys.getEnv('USERPROFILE') + PD;
			
			if (FileSystem.exists(user + 'pony_user_path_bak.txt')) {
				Sys.println('Error: path ready');
				return;
			}
			
			var stdout = new Process('cmd.exe', ['/C', 'install\\user_path.cmd']).stdout;
			var data = stdout.readAll();
			var path = StringTools.trim(data.toString());
			
			if (path != '') {
				var np = path + (path.substr(-1) == ';' ? '' : ';') + '%$ENVKEY%';
				setx('PATH', np);
				setx(ENVKEY, BIN);
			} else {
				Sys.println('ERROR');
			}

		} else if (envPath != BIN) {
			setx(ENVKEY, BIN);
		}
	}

	private inline function setx(v:String, p:String):Void cmd('setx', [v, p]);

	private function writeProfileFiles(pFiles:Array<String>):Void {
		var data = [
			'export $ENVKEY=$BIN',
			"export PATH=$PATH:$" + ENVKEY
		];

		if (installNodePath && Utils.nodeExists) {
			var line = 'export NODE_PATH=${Utils.npmPath}';
			if (installPonyPath) {
				data.unshift(line);
			} else {
				saveNpmLine(line, pFiles);
			}
		}

		if (!installPonyPath) return;

		for (pFile in pFiles) {
			if (FileSystem.exists(pFile)) {
				var c = File.getContent(pFile);
				if (c.indexOf(ENVKEY) == -1) {
					File.saveContent(pFile, c + '\n' + data.join('\n'));
				} else {
					var d1 = c.split('$ENVKEY=');
					var d2 = d1[1].split('\n');
					d2.shift();
					var s = d1[0] + ENVKEY + '=' + BIN + '\n' + d2.join('\n');
					File.saveContent(pFile, s);
				}
			} else {
				File.saveContent(pFile, data.join('\n'));
			}
		}
	}

	public static function saveNpmLine(line:String, pFiles:Array<String>):Void {
		for (pFile in pFiles) {
			if (FileSystem.exists(pFile)) {
				var c = File.getContent(pFile);
				if (c.indexOf(line) == -1) {
					File.saveContent(pFile, c + '\n' + line + '\n');
				}
			} else {
				File.saveContent(pFile, line + '\n');
			}
		}
	}

}