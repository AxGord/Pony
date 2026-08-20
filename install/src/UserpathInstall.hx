import haxe.io.Bytes;
import haxe.io.Input;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import Config.*;

using StringTools;

/**
 * UserpathInstall
 * @author AxGord <axgord@gmail.com>
 */
class UserpathInstall extends BaseInstall {

	private var installNodePath: Bool = true;
	private var installPonyPath: Bool = true;

	public function new() {
		installNodePath = questionState('nodepath') != InstallQuestion.No;
		installPonyPath = questionState('ponypath') != InstallQuestion.No;
		super('userpath', true, true);
	}

	override public function run(): Void {
		switch OS {
			case Windows:
				if (installNodePath && Utils.nodeExists) windowsNodeUserpath();
				if (installPonyPath) windowsPonyUserpath();
			case Mac:
				final home: String = Sys.getEnv('HOME');
				writeProfileFiles(['$home/.bash_profile', '$home/.zshrc']);
				log('Type "source ~/.bash_profile" for finish install');
			case Linux:
				final home: String = Sys.getEnv('HOME');
				final pfile: String = '$home/.profile';
				writeProfileFiles([pfile]);
				log('Type "source ~/.profile" for finish install');
		}
	}

	private inline function windowsNodeUserpath(): Void {
		if (Sys.getEnv('NODE_PATH') != null) return;
		final modulespath: String = Sys.getEnv('appdata') + PD + 'npm' + PD + 'node_modules';
		setx('NODE_PATH', modulespath);
	}

	private inline function windowsPonyUserpath(): Void {
		final envPath: String = Sys.getEnv(ENVKEY);
		if (envPath == null) {
			final user: String = Sys.getEnv('USERPROFILE') + PD;
			if (FileSystem.exists('${user}pony_user_path_bak.txt')) {
				Sys.println('Error: path ready');
				return;
			}

			final stdout: Input = new Process('cmd.exe', ['/C', 'install\\user_path.cmd']).stdout;
			final data: Bytes = stdout.readAll();
			final path: String = data.toString().trim();

			if (path != '') {
				final np: String = path + (path.substr(-1) == ';' ? '' : ';') + '%$ENVKEY%';
				setx('PATH', np);
				setx(ENVKEY, BIN);
			} else {
				Sys.println('ERROR');
			}

		} else if (envPath != BIN) {
			setx(ENVKEY, BIN);
		}
	}

	private inline function setx(v: String, p: String): Void cmd('setx', [v, p]);

	private function writeProfileFiles(pFiles: Array<String>): Void {
		final data: Array<String> = ['export $ENVKEY=$BIN', "export PATH=$PATH:$" + ENVKEY];

		if (installNodePath && Utils.nodeExists) {
			final line: String = 'export NODE_PATH=${Utils.npmPath}';
			if (installPonyPath) {
				data.unshift(line);
			} else {
				saveNpmLine(line, pFiles);
			}
		}

		if (!installPonyPath) return;

		for (pFile in pFiles) {
			if (FileSystem.exists(pFile)) {
				final c: String = File.getContent(pFile);
				if (c.indexOf(ENVKEY) == -1) {
					File.saveContent(pFile, '$c\n' + data.join('\n'));
				} else {
					final d1: Array<String> = c.split('$ENVKEY=');
					final d2: Array<String> = d1[1].split('\n');
					d2.shift();
					final s: String = d1[0] + ENVKEY + '=' + BIN + '\n' + d2.join('\n');
					File.saveContent(pFile, s);
				}
			} else {
				File.saveContent(pFile, data.join('\n'));
			}
		}
	}

	public static function saveNpmLine(line: String, pFiles: Array<String>): Void {
		for (pFile in pFiles) {
			if (FileSystem.exists(pFile)) {
				final c: String = File.getContent(pFile);
				if (c.indexOf(line) == -1) {
					File.saveContent(pFile, '$c\n$line\n');
				}
			} else {
				File.saveContent(pFile, '$line\n');
			}
		}
	}

}
