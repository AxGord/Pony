package module;

import pony.Fast;
import pony.text.TextTools;

import types.BASection;
import types.ImageminConfig;

/**
 * Imagemin module
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
class Imagemin extends NModule<ImageminConfig> {

	private static inline var PRIORITY: Int = 22;

	public function new() super('imagemin');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new ImageminReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			from: '',
			to: '',
			recursive: false,
			jpgq: 85,
			webpq: 50,
			webpfrompng: false,
			jpgfrompng: false,
			fast: false,
			checkHash: false,
			ignore: [],
			allowCfg: false,
			cordova: false
		}, configHandler);
	}

	#if (haxe_ver < 4.2) override #end
	private function writeCfg(protocol: NProtocol, cfg: Array<ImageminConfig>): Void {
		var hash: Null<module.Hash> = cast modules.getModule(module.Hash);
		if (hash != null && hash.xml != null) for (c in cfg)
			if (c.checkHash) c.ignore = c.ignore.concat(hash.getNotChangedUnits());
		protocol.imageminRemote(cfg);
	}

}

@SuppressWarnings('checkstyle:MagicNumber')
private class ImageminReader extends BAReader<ImageminConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.from = '';
		cfg.to = '';
		cfg.recursive = false;
		cfg.format = null;
		cfg.pngq = null;
		cfg.jpgq = 85;
		cfg.webpq = 50;
		cfg.webpfrompng = false;
		cfg.jpgfrompng = false;
		cfg.fast = false;
		cfg.checkHash = false;
		cfg.ignore = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'from': cfg.from += val;
			case 'to': cfg.to += val;
			case 'recursive': cfg.recursive = TextTools.isTrue(val);
			case 'format': cfg.format = val;
			case 'pngq': cfg.pngq = Std.parseInt(val);
			case 'jpgq': cfg.jpgq = Std.parseInt(val);
			case 'webpq': cfg.webpq = Std.parseInt(val);
			case 'webpfrompng': cfg.webpfrompng = TextTools.isTrue(val);
			case 'jpgfrompng': cfg.jpgfrompng = TextTools.isTrue(val);
			case 'fast': cfg.fast = TextTools.isTrue(val);
			case 'checkHash': cfg.checkHash = TextTools.isTrue(val);
			case _:
		}
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'dir': allowCreate(xml);
			case 'path': denyCreate(xml);
			case _: super.readNode(xml);
		}
	}

}