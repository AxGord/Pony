package module;

import pony.Fast;
import pony.ds.Triple;
import sys.FileSystem;
import types.BASection;
import types.DownloadConfig;

using StringTools;
using pony.text.XmlTools;

/**
 * Donwload module
 * @author AxGord <axgord@gmail.com>
 */
class Download extends NModule<DownloadConfig> {

	private static inline final PRIORITY: Int = 30;

	public function new() super('download');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new DownloadReader(
			xml,
			{ debug: ac.debug, app: ac.app, before: false, section: BASection.Prepare, path: '', units: [], allowCfg: true, cordova: false },
			configHandler
		);
	}

	#if (haxe_ver < 4.2) override #end
	private function writeCfg(protocol: NProtocol, cfg: Array<DownloadConfig>): Void {
		for (c in cfg) FileSystem.createDirectory(c.path);
		protocol.downloadRemote(cfg);
	}

}

private class DownloadReader extends BAReader<DownloadConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
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
				final url: String = xml.att.url;
				final update: Bool = xml.isTrue('update');
				final p: Triple<String, String, Bool> = if (xml.has.v) {
					final v: String = xml.att.v;
					new Triple(url.replace('{v}', v), xml.has.check ? StringTools.replace(xml.att.check, '{v}', v) : null, update);
				} else {
					new Triple(url, xml.has.check ? xml.att.check : null, update);
				}
				cfg.units.push(p);
			case _:
				super.readNode(xml);
		}
	}

}
