package module;

import pony.Fast;

import types.BASection;
import types.PoeditorConfig;

/**
 * Poeditor module
 * @author AxGord <axgord@gmail.com>
 */
class Poeditor extends NModule<PoeditorConfig> {

	private static inline var PRIORITY: Int = 32;

	public function new() super('poeditor');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new PoeditorReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			path: '',
			id: null,
			token: null,
			list: null,
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	#if (haxe_ver < 4.2) override #end
	private function writeCfg(protocol: NProtocol, cfg: Array<PoeditorConfig>): Void {
		for (c in cfg) sys.FileSystem.createDirectory(c.path);
		protocol.poeditorRemote(cfg);
	}

}

private class PoeditorReader extends BAReader<PoeditorConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.path = '';
		cfg.id = null;
		cfg.token = null;
		cfg.list = null;
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': cfg.path = StringTools.trim(xml.innerData);
			case 'id': cfg.id = Std.parseInt(xml.innerData);
			case 'token': cfg.token = StringTools.trim(xml.innerData);
			case 'list': cfg.list = [for (x in xml.elements) StringTools.trim(x.innerData) => x.name];
			case _: super.readNode(xml);
		}
	}

}