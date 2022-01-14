package module;

import haxe.crypto.Base64;
import haxe.crypto.Sha1;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

import pony.Fast;
import pony.fs.File;

using pony.Tools;
using pony.text.XmlTools;

/**
 * Template module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Template extends CfgModule<TemplateConfig> {

	private static inline var PRIORITY: Int = 6;

	private var hash: Null<String> = null;
	private var usedFiles: Map<String, Bytes> = new Map<String, Bytes>();

	public function new() super('template');

	override public function init(): Void initSections(PRIORITY, Build);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new TemplateReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Build,
			to: '',
			from: '',
			title: '',
			appFile: null,
			appPath: '',
			hash: null,
			units: [],
			cordova: false,
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg: TemplateConfig): Void {
		var hash: Null<module.Hash> = cast modules.getModule(module.Hash);
		var hashMethod: (String -> Dynamic) -> String -> String = hashFile.bind(hash, cfg.from, cfg.to);
		var appHash: String = cfg.appFile == null ? '' : Base64.urlEncode(Utils.gitHash(cfg.appPath + cfg.appFile));
		var appFileName: String = '';
		if (cfg.appFile != null) {
			var appFile: File = cfg.appPath + cfg.appFile;
			var newFile: File = '${appFile.withoutExt}.$appHash.${appFile.ext}';
			appFile.rename(newFile);
			appFileName = newFile.name;
		}
		for (unit in cfg.units) {
			var file: File = cfg.from + unit;
			var content: Null<String> = file.content;
			if (content == null) continue;
			(((cfg.to + unit): File).withoutExt: File).content = new haxe.Template(content).execute({
				title: cfg.title,
				app: appFileName,
				appHash: appHash,
				assetsHash: hash != null && hash.xml != null ? hash.getHashHash() : '',
				buildDate: Date.now().toString()
			}, { hash: hashMethod });
		}
		if (cfg.hash != null && Lambda.count(usedFiles) > 0) ((cfg.to + cfg.hash): File).bytes = new pony.ui.Hash(usedFiles).toBytes();
	}

	private function hashFile(hash: Null<module.Hash>, from: String, to: String, resolve: String -> Dynamic, fileName: String): String {
		if (hash == null) return fileName;
		var bytes: Null<Bytes> = usedFiles[fileName];
		var file: File = fileName;
		if (bytes != null) return [file.withoutExt, Base64.urlEncode(bytes), file.ext].join('.');
		var fromFile: File = from + fileName;
		if (!fromFile.exists) return fileName;
		var bytes: Bytes = Utils.gitHash(fromFile.first);
		usedFiles[fileName] = bytes;
		var newName: String = [file.withoutExt, Base64.urlEncode(bytes), file.ext].join('.');
		fromFile.copyToFile(to + newName);
		return newName;
	}

}

private typedef TemplateConfig = {
	> types.BAConfig,
	to: String,
	from: String,
	title: String,
	appFile: Null<String>,
	appPath: String,
	hash: Null<String>,
	units: Array<String>
}

@:nullSafety(Strict) private class TemplateReader extends BAReader<TemplateConfig> {

	override private function clean(): Void {
		cfg.to = '';
		cfg.from = '';
		cfg.title = '';
		cfg.appFile = null;
		cfg.hash = null;
		cfg.units = [];
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'title': cfg.title = normalize(xml.innerData);
			case 'app':
				cfg.appFile = normalize(xml.innerData);
				cfg.appPath = xml.has.path ? normalize(xml.att.path) : '';
			case 'unit': cfg.units.push(normalize(xml.innerData));
			case _: super.readNode(xml);
		}
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'to': cfg.to = val;
			case 'from': cfg.from = val;
			case 'hash': cfg.hash = val;
			case _:
		}
	}

}