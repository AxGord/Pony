/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

enum OS {
	Windows;
	Mac;
	Linux;
}

/**
 * Install Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {

	static inline var envkey:String = 'PONYTOOLS_PATH';
	
	static function main():Void {

		var system:OS = OS.createByName(Sys.systemName());
		var pd = system == Windows ? '\\' : '/';
		var toolsSrc = Sys.getCwd() + 'tools';
		toolsSrc = StringTools.replace(toolsSrc, '/', pd);
		var toolshome = toolsSrc + pd + 'bin' + pd;

		var args = Sys.args();
		if (args.length > 1) {
			Sys.setCwd(args.pop());
			var runfile = toolshome + (system == Windows ? 'pony.exe' : 'pony');
			if (sys.FileSystem.exists(runfile)) {
				Sys.exit(Sys.command(runfile, args));
			} else  {
				Sys.println('Pony not compiled');
				Sys.exit(1);
			}
		}
		Sys.println('Install Pony Command-Line Tools...');
		
		Sys.println('Install haxelibs');
		for (m in ['hxnodejs', 'hxbit'])
			Sys.command('haxelib', ['install', m]);

		Sys.println('Compile pony');
		
		Sys.command('haxe', ['--cwd', toolsSrc, 'build.hxml']);
		
		FileSystem.deleteFile(toolshome + 'pony.n');

		switch system {
			case Windows:
				installNpms();

				Sys.println('Add user path to pony.exe');
				
				if (Sys.getEnv('NODE_PATH') == null) {
					Sys.println('Set NODE_PATH');
					var modulespath = Sys.getEnv('appdata') + pd + 'npm' + pd + 'node_modules';
					Sys.command('setx', ['NODE_PATH', modulespath]);
				}
				
				var envPath:String = Sys.getEnv(envkey);
				
				if (envPath == null) {
				
					var user = Sys.getEnv('USERPROFILE') + pd;
					
					if (FileSystem.exists(user + 'pony_user_path_bak.txt')) {
						Sys.println('Error: path ready');
						return;
					}
					
					var stdout = new Process('cmd.exe', ['/C', 'install\\user_path.cmd']).stdout;
					var data = stdout.readAll();
					var path = StringTools.trim(data.toString());
					
					if (path != '') {
						var np = path + (path.substr(-1) == ';' ? '': ';') + '%$envkey%';
						Sys.println('Set new PATH: $np');
						Sys.command('setx', ['PATH', np]);
						Sys.println('Set new $envkey: $toolshome');
						Sys.command('setx', [envkey, toolshome]);
					} else {
						Sys.println('ERROR');
					}

				} else if (envPath != toolshome) {
					Sys.println('Set new $envkey: $toolshome');
					Sys.command('setx', [envkey, toolshome]);
				}
				printSuccess();

			case Mac:
				installNpms(true);

				var home = Sys.getEnv('HOME');
				writeProfileFiles([home + '/.bash_profile', home + '/.zshrc'], toolshome);
				printSuccess();		

			case Linux:
				installNpms(true);
				
				var home = Sys.getEnv('HOME');
				var pfile = home + '/.profile';
				writeProfileFiles([pfile], toolshome);
				printSuccess();

		}
	}
	
	private static function printSuccess():Void Sys.println('Installation complete, reenter');

	private static function installNpms(?sudo:Bool):Void {
		Sys.println('Install npm');

		//Sys.command('sudo', ['chmod', '/usr/local/lib/node_modules', '777']);	

		var npm:Array<String> = [
			'git+https://github.com/janjakubnanista/poeditor-client.git',
			'uglify-js@3.3.11',
			'ftp@0.3.10',
			'send@0.16.2',
			'multiparty@4.1.3',
			'http-proxy@1.16.2',
			'source-map-support@0.5.3',
			'convert-source-map@1.5.1',
			'offset-sourcemap-lines@1.0.0',
			'msdf-bmfont-xml@2.3.4'
		];
		if (sudo)
			for (m in npm) Sys.command('sudo', ['npm', '-g', 'install', m]);
		else
			for (m in npm) Sys.command('npm', ['-g', 'install', m]);
	}

	private static function writeProfileFiles(pFiles:Array<String>, toolshome:String):Void {

		Sys.println('Add user path to ponytools');
		var npmPath = new Process('npm', ['prefix', '-g']).stdout.readLine()+'/lib/node_modules';
			
		var data = [
			'export NODE_PATH=$npmPath',
			'export $envkey=$toolshome',
			"export PATH=$PATH:$" + envkey
		];

		for (pFile in pFiles) {
			if (FileSystem.exists(pFile)) {
				var c = File.getContent(pFile);
				if (c.indexOf(envkey) == -1) {
					File.saveContent(pFile, c + "\n" + data.join('\n'));
				} else {
					var d1 = c.split('$envkey=');
					var d2 = d1[1].split('\n');
					d2.shift();
					var s = d1[0] + envkey + '=' + toolshome + '\n' + d2.join('\n');
					File.saveContent(pFile, s);
				}
			} else {
				File.saveContent(pFile, data.join('\n'));
			}
		}


	}
	
}