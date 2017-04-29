import sys.FileSystem;
import sys.io.File;

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
		
		Sys.println('Compile pony.exe');
		
		Sys.command('haxe', ['--cwd', toolsSrc, 'build.hxml']);
		
		FileSystem.deleteFile(toolshome + 'pony.n');
		
		switch Sys.systemName() {
			case 'Windows':
		
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
				
				Sys.println('Installation complete, please reenter in command line and use pony');

			case _:
				Sys.println('Not supported OS');
				return;
		}
	}
	
}