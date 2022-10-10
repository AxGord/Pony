using StringTools;

/**
 * HaxelibInstall
 * @author AxGord <axgord@gmail.com>
 */
class HaxelibInstall extends BaseInstall {

	public function new() super('haxelibs', false, true);

	override private function run(): Void {
		listInstall('haxelib', ['install'], Config.settings.haxelib, isNoSsl() ? ['-R', 'http://lib.haxe.org/'] : []);
	}

	private function isNoSsl(): Bool {
		var v: String = Sys.getEnv('HAXELIB_NO_SSL');
		if (v != null) v = v.trim().toLowerCase();
		return v == '1' || v == 'true';
	}

}