import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

/**
 * Install Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {
	
	static function main() {
		
		var PD = Sys.systemName() == 'Windows' ? '\\' : '/';

		Sys.println('Install Pony Command-Line Tools...');
		var toolsSrc = Sys.getCwd() + 'tools';
		toolsSrc = StringTools.replace(toolsSrc, '/', PD);
		var toolshome = toolsSrc + PD + 'bin' + PD;
		
		Sys.println('Install haxelibs');		
		for (m in ['hxnodejs'])
			Sys.command('haxelib', ['install', m]);

		Sys.println('Compile pony.exe');
		
		Sys.command('haxe', ['--cwd', toolsSrc, 'build.hxml']);
		
		FileSystem.deleteFile(toolshome + 'pony.n');

		//Sys.command('sudo', ['chmod', '/usr/local/lib/node_modules', '777']);

		var npm:Array<String> = ['https://github.com/janjakubnanista/poeditor-client.git', 'uglify-js', 'ftp', 'send', 'multiparty', 'http-proxy'];

		Sys.println('Install npm');

		switch Sys.systemName() {
			case 'Windows':

				for (m in npm) Sys.command('npm', ['-g', 'install', m]);		

				var path = Sys.getEnv('PATH');
				
				Sys.println('Add user path to pony.exe');
				
				if (Sys.getEnv('NODE_PATH') == null) {
					Sys.println('Set NODE_PATH');
					var modulespath = Sys.getEnv('appdata') + PD + 'npm' + PD + 'node_modules';
					Sys.command('setx', ['NODE_PATH', modulespath]);
				}
				
				var user = Sys.getEnv('USERPROFILE') + PD;
				
				if (FileSystem.exists(user + 'pony_user_path_bak.txt')) {
					Sys.println('path ready');
					return;
				}		
				Sys.command('install'+PD+'append_user_path.cmd', [toolshome]);
				
				Sys.println('Installation complete, please reboot system');

			case 'Mac':

				for (m in npm) Sys.command('sudo', ['npm', '-g', 'install', m]);

				Sys.println('Add user path to ponytools');
				var home = Sys.getEnv('HOME');
				var pFiles = [home + '/.bash_profile', home + '/.zshrc'];
				var npmPath = new Process('npm', ['prefix', '-g']).stdout.readLine()+'/lib/node_modules';
				
				var data = [
					"export NODE_PATH="+npmPath,
					"export PONYTOOLS_PATH="+toolshome,
					"export PATH=$PATH:$PONYTOOLS_PATH"
				];

				for (pFile in pFiles) {
					if (FileSystem.exists(pFile)) {
						var c = File.getContent(pFile);
						if (c.indexOf('PONYTOOLS_PATH') == -1) {
							File.saveContent(pFile, c + "\n" + data.join('\n'));
						} else {
							var d1 = c.split('PONYTOOLS_PATH=');
							var d2 = d1[1].split('\n');
							d2.shift();
							var s = d1[0] + 'PONYTOOLS_PATH=' + toolshome + '\n' + d2.join('\n');
							File.saveContent(pFile, s);
						}
					} else {
						File.saveContent(pFile, data.join('\n'));
					}
				}

				Sys.println('Installation complete, please reenter in command line');				

			case _:
				Sys.println('Not supported OS');
				return;
		}
	}
	
}