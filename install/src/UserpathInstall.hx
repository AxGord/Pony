
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
import Config.*;

/**
 * UserpathInstall
 * @author AxGord <axgord@gmail.com>
 */
class UserpathInstall extends BaseInstall {

	public function new() super('user path', true, true);

	override public function run():Void {
		switch Config.OS {
			case Windows:
				if (Utils.nodeExists)
					windowsNodeUserpath();
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

	private static function writeProfileFiles(pFiles:Array<String>):Void {
		var npmPath = new Process('npm', ['prefix', '-g']).stdout.readLine() + '/lib/node_modules';
			
		var data = [
			'export NODE_PATH=$npmPath',
			'export $ENVKEY=$BIN',
			"export PATH=$PATH:$" + ENVKEY
		];

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

}