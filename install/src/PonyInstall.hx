/**
 * PonyInstall
 * @author AxGord <axgord@gmail.com>
 */
class PonyInstall extends BaseInstall {

	public function new() super('Pony Command-Line Tools', !Config.INSTALL, true);

	override private function run():Void {
		new VSCodePluginsInstall();
		new HaxelibInstall();
		compile();
		new NpmInstall();
		new UserpathInstall();
	}

	private inline function compile():Void {
		log('Compile pony');
		Utils.beginColor(90);
		cmd('haxe', ['--cwd', Config.SRC, 'build.hxml']);
		Utils.endColor();
		sys.FileSystem.deleteFile(Config.BIN + 'pony.n');
	}

}