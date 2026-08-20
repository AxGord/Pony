/**
 * NpmInstall
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) final class NpmInstall extends BaseInstall {

	private static inline final PRIV_ALL: Int = 777;

	private var sudo: Bool = false;

	public function new() {
		if (Utils.nodeExists) {
			sudo = Config.OS != TargetOS.Windows;
			super('npm', true, false);
		}
	}

	override private function run(): Void {
		final cmds: Array<String> = ['npm', '-g', 'install'];
		var perm: Int = -1;
		var homeperm: Int = -1;
		if (sudo) {
			if (Utils.isSuper) {
				Utils.md(Utils.npmPath);
				Utils.md(Utils.homeNpm);
			} else {
				graylog('Npm path: ${Utils.npmPath}');
				Utils.md(Utils.npmPath);
				perm = Utils.getPerm(Utils.npmPath);
				graylog('Npm dir perm $perm');
				if (perm == PRIV_ALL) perm = -1;
				graylog('Home npm path: ${Utils.npmPath}');
				Utils.md(Utils.homeNpm);
				homeperm = Utils.getPerm(Utils.homeNpm);
				graylog('Home npm dir perm $homeperm');
				if (homeperm == PRIV_ALL) homeperm = -1;
				if (perm != -1) Utils.setPerm(Utils.npmPath, PRIV_ALL, true);
				if (homeperm != -1) Utils.setPerm(Utils.homeNpm, PRIV_ALL, true);
			}
		}
		final c: String = cast cmds.shift();
		if (Config.OS == TargetOS.Windows) {
			final winmap: Map<String, String> = [
				for (e in Config.settings.winnpm) {
					final a = e.split('@');
					a[0] => a[1];
				}
			];
			listInstall(c, cmds, [
				for (npm in Config.settings.npm) {
					final n: String = npm.split('@')[0];
					winmap.exists(n) ? '$n@${winmap[n]}' : npm;
				}
			]);
		} else {
			listInstall(c, cmds, Config.settings.npm);
		}
		if (perm != -1) Utils.setPerm(Utils.npmPath, perm, true);
		if (homeperm != -1) Utils.setPerm(Utils.homeNpm, homeperm, true);
	}

}
