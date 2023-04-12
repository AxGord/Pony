package module;

import haxe.crypto.Base64;
import haxe.io.Bytes;

import pony.Fast;
import pony.ds.STriple;
import pony.fs.File;

using StringTools;

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

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, Build);

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
			appRm: true,
			appPath: '',
			hash: null,
			units: [],
			files: [],
			cordova: false,
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg: TemplateConfig): Void {
		var hashModule: Null<module.Hash> = cast modules.getModule(module.Hash);
		var assetsHashFile: Null<STriple<String>> = hashModule != null && hashModule.xml != null ? hashModule.getBuildResHashFile() : null;
		var buildDate: String = Date.now().toString();
		var hashMethod: (String -> Dynamic) -> String -> String = hashFile.bind(cfg.from, cfg.to, false);
		var appFileName: String = cfg.appFile != null ? hashFile(cfg.appPath, cfg.to, cfg.appRm, dummy, cfg.appFile) : '';
		var assetsHash: String = assetsHashFile != null ? hashFile(assetsHashFile.a, assetsHashFile.b, false, dummy, assetsHashFile.c) : '';
		for (unit in cfg.units) {
			var file: File = cfg.from + unit;
			var content: Null<String> = file.content;
			if (content == null) continue;
			(((cfg.to + unit): File).withoutExt: File).content = new haxe.Template(content).execute({
				title: cfg.title,
				app: appFileName,
				assetsHash: assetsHash,
				buildDate: buildDate,
			}, { hash: hashMethod });
		}
		for (file in cfg.files) {
			var f: File = cfg.from + file;
			f.copyToDir(cfg.to);
			if (cfg.hash != null) usedFiles[file] = Utils.gitHash(f.first);
		}
		if (cfg.hash != null && Lambda.count(usedFiles) > 0) ((cfg.to + cfg.hash): File).bytes = new pony.ui.Hash(usedFiles).toBytes();
	}

	private function hashFile(from: String, to: String, rm: Bool, resolve: String -> Dynamic, fileName: String): String {
		if (from.length > 0 && !from.endsWith('/')) from += '/';
		if (to.length > 0 && !to.endsWith('/')) to += '/';
		var bytes: Null<Bytes> = usedFiles[fileName];
		var file: File = fileName;
		if (bytes != null) return [file.withoutExt, Base64.urlEncode(bytes), file.ext].join('.');
		var fromFile: File = from + fileName;
		if (!fromFile.exists) return fileName;
		var bytes: Bytes = Utils.gitHash(fromFile.first);
		usedFiles[fileName] = bytes;
		var newName: String = [file.withoutExt, Base64.urlEncode(bytes), file.ext].join('.');
		fromFile.copyToFile(to + newName);
		if (rm) fromFile.delete();
		return newName;
	}

	private static function dummy(s: String): Dynamic return s;

}

private typedef TemplateConfig = {
	> types.BAConfig,
	to: String,
	from: String,
	title: String,
	appFile: Null<String>,
	appPath: String,
	appRm: Bool,
	hash: Null<String>,
	units: Array<String>,
	files: Array<String>
}

@:nullSafety(Strict) private class TemplateReader extends BAReader<TemplateConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.to = '';
		cfg.from = '';
		cfg.title = '';
		cfg.appFile = null;
		cfg.appRm = true;
		cfg.hash = null;
		cfg.units = [];
		cfg.files = [];
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'title': cfg.title = normalize(xml.innerData);
			case 'app':
				cfg.appFile = normalize(xml.innerData);
				cfg.appPath = xml.has.path ? normalize(xml.att.path) : '';
				cfg.appRm = !xml.isFalse('rm');
			case 'unit': cfg.units.push(normalize(xml.innerData));
			case 'file': cfg.files.push(normalize(xml.innerData));
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