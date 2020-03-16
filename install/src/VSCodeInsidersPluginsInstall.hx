/**
 * VSCodeInsidersPluginsInstall
 * @author AxGord <axgord@gmail.com>
 */
class VSCodeInsidersPluginsInstall extends BaseInstall {

	public function new() if (Utils.codeInsidersExists) super('vscode insiders plugins', 'code-insiders', true, false);

	override private function run(): Void listInstall('code-insiders', ['--install-extension'], Config.settings.vscode);

}