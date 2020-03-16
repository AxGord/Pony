/**
 * HaxelibInstall
 * @author AxGord <axgord@gmail.com>
 */
class HaxelibInstall extends BaseInstall {

	public function new() super('haxelibs', false, true);

	override private function run(): Void listInstall('haxelib', ['install'], Config.settings.haxelib);

}