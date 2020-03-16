/**
 * VSCodePluginsInstall
 * @author AxGord <axgord@gmail.com>
 */
class VSCodePluginsInstall extends BaseInstall {

	public function new() if (Utils.codeExists) super('vscode plugins', 'code', true, false);

	override private function run(): Void listInstall('code', ['--install-extension'], Config.settings.vscode);

}