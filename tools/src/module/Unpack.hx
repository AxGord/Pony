package module;

import pony.Fast;

import types.BASection;

using pony.text.XmlTools;

/**
 * Unpack module
 * @author AxGord <axgord@gmail.com>
 */
class Unpack extends Module {

	private static inline var PRIORITY: Int = 6;

	private var beforeZips: Map<BASection, Array<ZipConfig>> = new Map();
	private var afterZips: Map<BASection, Array<ZipConfig>> = new Map();

	public function new() super('unpack');

	override public function init(): Void {
		if (xml == null) return;
		addConfigListener();
		addListeners(PRIORITY, before, after);
		modules.commands.onUnpack < start;
	}

	private function start(): Void {
		for (c in afterZips[BASection.Unpack]) unzip(c);
	}

	override private function runModule(before: Bool, section: BASection): Void {}

	override private function readConfig(ac: AppCfg): Void {
		new UnpackReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Unpack,
			zips: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	private function configHandler(cfg: UnpackConfig): Void {
		if (cfg.zips.length == 0) return;
		if (cfg.before) {
			if (beforeZips.exists(cfg.section))
				beforeZips[cfg.section] = beforeZips[cfg.section].concat(cfg.zips);
			else
				beforeZips[cfg.section] = cfg.zips;
		} else {
			if (afterZips.exists(cfg.section))
				afterZips[cfg.section] = afterZips[cfg.section].concat(cfg.zips);
			else
				afterZips[cfg.section] = cfg.zips;
		}
	}

	private function before(section: BASection): Void {
		if (section == BASection.Unpack) return;
		if (!beforeZips.exists(section)) return;
		for (c in beforeZips[section]) unzip(c);
	}

	private function after(section: BASection): Void {
		if (section == BASection.Unpack) return;
		if (!afterZips.exists(section)) return;
		for (c in afterZips[section]) unzip(c);
	}

	private function unzip(c: ZipConfig): Void {
		log('Unzip: ' + c.file);
		pony.ZipTool.unpackFile(c.file, c.path, c.log ? function(s: String) log(s) : null);
		if (c.rm) {
			log('Delete: ' + c.file);
			sys.FileSystem.deleteFile(c.file);
		}
	}

}

private typedef ZipConfig = {
	path: String,
	file: String,
	rm: Bool,
	log: Bool
}

private typedef UnpackConfig = {
	> types.BAConfig,
	zips: Array<ZipConfig>
}

private class UnpackReader extends BAReader<UnpackConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'zip':
				cfg.zips.push({
					path: try StringTools.trim(xml.innerData) catch (_:Any) '',
					file: xml.att.file,
					rm: xml.isTrue('rm'),
					log: !xml.isFalse('log')
				});
			case _:
				super.readNode(xml);
		}
	}

	override private function clean(): Void {
		cfg.zips = [];
	}

}