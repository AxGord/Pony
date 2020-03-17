package module;

import sys.FileSystem;
import pony.ds.Triple;
import pony.fs.File;
import pony.Fast;
import types.BASection;
import types.DownloadConfig;

using pony.text.XmlTools;

/**
 * Donwload module
 * @author AxGord <axgord@gmail.com>
 */
class Download extends NModule<DownloadConfig> {

	private static inline var PRIORITY: Int = 30;

	public function new() super('download');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new DownloadReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			path: '',
			units: [],
			allowCfg: true
		}, configHandler);
	}

	override private function writeCfg(protocol: NProtocol, cfg: Array<DownloadConfig>): Void {
		for (c in cfg) FileSystem.createDirectory(c.path);
		protocol.downloadRemote(cfg);
	}

}

private class DownloadReader extends BAReader<DownloadConfig> {

	override private function clean(): Void {
		cfg.path = '';
		cfg.units = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'path': cfg.path += val;
			case _:
		}
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {

			case 'unit':

				var url: String = xml.att.url;
				var update: Bool = !xml.isFalse('update');
				var p: Triple<String, String, Bool> = if (xml.has.v) {
					var v: String = xml.att.v;
					new Triple(
						StringTools.replace(url, '{v}', v),
						xml.has.check ? StringTools.replace(xml.att.check, '{v}', v) : null,
						update
					);
				} else {
					new Triple(url, xml.has.check ? xml.att.check : null, update);
				}
				cfg.units.push(p);

			case _:
				super.readNode(xml);
		}
	}

}