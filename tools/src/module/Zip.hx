package module;

import haxe.xml.Fast;
import types.BASection;

/**
 * Zip
 * @author AxGord <axgord@gmail.com>
 */
class Zip extends CfgModule<ZipConfig> {

	private static inline var PRIORITY:Int = 12;

	public function new() super('zip');

	override public function init():Void initSections(PRIORITY, BASection.Zip);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new ZipConfigReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Zip,
			input: [],
			output: 'app.zip',
			prefix: 'bin/',
			compressLvl: 9,
			log: true,
			hash: null,
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:ZipConfig):Void {
		log('Archive name: ${cfg.output}');
		var zip = new pony.ZipTool(Utils.replaceBuildDate(cfg.output), cfg.prefix, cfg.compressLvl);
		if (cfg.log) zip.onLog << log;
		zip.onError << function(err:String) throw err;
		if (cfg.hash != null)
			zip.writeHash(Utils.getHashes(cfg.hash));
		zip.writeList(cfg.input).end();
	}

}

private typedef ZipConfig = { > types.BAConfig,
	input: Array<String>,
	output: String,
	prefix: String,
	compressLvl: Int,
	hash: String,
	log: Bool
}

private class ZipConfigReader extends BAReader<ZipConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'input': cfg.input.push(StringTools.trim(xml.innerData));
			case 'output': cfg.output = StringTools.trim(xml.innerData);
			case 'prefix': cfg.prefix = StringTools.trim(xml.innerData);
			case 'compress': cfg.compressLvl = Std.parseInt(xml.innerData);
			case 'hash': cfg.hash = StringTools.trim(xml.innerData);

			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.input = [];
		cfg.output = 'app.zip';
		cfg.prefix = 'bin/';
		cfg.compressLvl = 9;
		cfg.hash = null;
		cfg.log = true;
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'log': cfg.log = !pony.text.TextTools.isFalse(val);
			case _:
		}
	}

}