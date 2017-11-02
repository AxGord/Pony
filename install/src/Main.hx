/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

		var npm:Array<String> = [
			//'https://github.com/janjakubnanista/poeditor-client.git',
			'uglify-js',
			'ftp',
			'send',
			'multiparty',
			'http-proxy',
			'source-map-support',
			'convert-source-map',
			'offset-sourcemap-lines'
		];

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