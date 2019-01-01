package module;

import pony.Pair;
import haxe.xml.Fast;
import types.BASection;
import types.DownloadConfig;
import pony.text.TextTools;

/**
 * Donwload module
 * @author AxGord <axgord@gmail.com>
 */
class Download extends NModule<DownloadConfig> {

	private static inline var PRIORITY:Int = 30;

	public function new() super('download');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
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

	override private function writeCfg(protocol:NProtocol, cfg:Array<DownloadConfig>):Void {
		for (c in cfg) sys.FileSystem.createDirectory(c.path);
		protocol.downloadRemote(cfg);
	}

}

private class DownloadReader extends BAReader<DownloadConfig> {

	override private function clean():Void {
		cfg.path = '';
		cfg.units = [];
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'path': cfg.path += val;
			case _:
		}
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'unit':
				var p:Pair<String, String> = if (xml.has.v) {
					var v = xml.att.v;
					new Pair(StringTools.replace(xml.att.url, '{v}', v), xml.has.check ? StringTools.replace(xml.att.check, '{v}', v) : null);
				} else {
					new Pair(xml.att.url, xml.has.check ? xml.att.check : null);
				}
				cfg.units.push(p);

			case _: super.readNode(xml);
		}
	}

}