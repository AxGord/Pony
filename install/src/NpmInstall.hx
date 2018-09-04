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

/**
 * NpmInstall
 * @author AxGord <axgord@gmail.com>
 */
class NpmInstall extends BaseInstall {

	private var sudo:Bool;

	public function new() {
		if (Utils.nodeExists) {
			this.sudo = Config.OS != TargetOS.Windows;
			super('npm', true, false);
		}
	}

	override private function run():Void {
		var cmds = ['npm', '-g', 'install'];
		var perm:Null<Int> = null;
		if (sudo) {
			perm = Utils.getPerm(Utils.npmPath);
			graylog('Npm dir perm $perm');
			if (perm == 777) perm = null;
			Utils.setPerm(Utils.npmPath, 777, true);
		}
		var c = cmds.shift();
		if (Config.OS == TargetOS.Windows) {
			var winmap:Map<String, String> = [for (e in Config.settings.winnpm) {
				var a = e.split('@');
				a[0] => a[1];
			}];
			listInstall(c, cmds, [for (npm in Config.settings.npm) {
				var n:String = npm.split('@')[0];
				if (winmap.exists(n))
					n + '@' + winmap[n];
				else
					npm;
			}]);
		} else {
			listInstall(c, cmds, Config.settings.npm);
		}
		if (perm != null)
			Utils.setPerm(Utils.npmPath, perm, true);
	}

}