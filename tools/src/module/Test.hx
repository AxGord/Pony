package module;

import pony.Fast;

import types.BASection;

/**
 * Test module
 * @author AxGord <axgord@gmail.com>
 */
class Test extends CfgModule<TestConfig> {

	private static inline var PRIORITY: Int = 5;

	public function new() super('test');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new TestReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Build,
			path: null,
			test: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: TestConfig): Void {
		var cwd: Cwd = cfg.path;
		cwd.sw();
		for (t in cfg.test) {
			var args = t.split(' ');
			var cmd = args.shift();
			Utils.command(cmd, args);
		}
		cwd.sw();
	}

}

private typedef TestConfig = {
	> types.BAConfig,
	path: String,
	test: Array<String>
}

private class TestReader extends BAReader<TestConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'test': cfg.test.push(StringTools.trim(xml.innerData));
			case _: super.readNode(xml);
		}
	}

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.path = null;
		cfg.test = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'test': cfg.path = val;
			case _:
		}
	}

}