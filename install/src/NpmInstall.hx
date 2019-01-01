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