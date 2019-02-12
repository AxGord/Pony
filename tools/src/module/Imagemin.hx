package module;

import pony.Fast;
import types.BASection;
import types.ImageminConfig;
import pony.text.TextTools;

/**
 * Imagemin module
 * @author AxGord <axgord@gmail.com>
 */
class Imagemin extends NModule<ImageminConfig> {

	private static inline var PRIORITY:Int = 22;

	public function new() super('imagemin');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new ImageminReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			from: '',
			to: '',
			jpgq: 85,
			webpq: 50,
			webpfrompng: false,
			jpgfrompng: false,
			allowCfg: false
		}, configHandler);
	}

	override private function writeCfg(protocol:NProtocol, cfg:Array<ImageminConfig>):Void protocol.imageminRemote(cfg);

}

private class ImageminReader extends BAReader<ImageminConfig> {

	override private function clean():Void {
		cfg.from = '';
		cfg.to = '';
		cfg.format = null;
		cfg.pngq = null;
		cfg.jpgq = 85;
		cfg.webpq = 50;
		cfg.webpfrompng = false;
		cfg.jpgfrompng = false;
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'from': cfg.from += val;
			case 'to': cfg.to += val;
			case 'format': cfg.format = val;
			case 'pngq': cfg.pngq = Std.parseInt(val);
			case 'jpgq': cfg.jpgq = Std.parseInt(val);
			case 'webpq': cfg.webpq = Std.parseInt(val);
			case 'webpfrompng': cfg.webpfrompng = TextTools.isTrue(val);
			case 'jpgfrompng': cfg.jpgfrompng = TextTools.isTrue(val);
			case _:
		}
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'dir': allowCreate(xml);
			case 'path': denyCreate(xml);

			case _: super.readNode(xml);
		}
	}

}
