package module;

import pony.Fast;
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
		var zip = new pony.ZipTool(
			Utils.replaceBuildDate(cfg.output),
			cfg.prefix,
			cfg.compressLvl,
			cfg.root == null ? null : Utils.replaceBuildDate(cfg.root)
		);
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
	log: Bool,
	?root: String
}

private class ZipConfigReader extends BAReader<ZipConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'input': cfg.input.push(normalize(xml.innerData));
			case 'output': cfg.output = normalize(xml.innerData);
			case 'prefix': cfg.prefix = normalize(xml.innerData);
			case 'compress': cfg.compressLvl = Std.parseInt(xml.innerData);
			case 'hash': cfg.hash = normalize(xml.innerData);
			case 'root':
				cfg.root = normalize(xml.innerData);
				if (cfg.root == '') cfg.root = null;
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
		cfg.root = null;
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'log': cfg.log = !pony.text.TextTools.isFalse(val);
			case _:
		}
	}

}