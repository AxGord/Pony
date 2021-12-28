package module;

import haxe.crypto.Base64;
import haxe.crypto.Sha1;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

import pony.Fast;
import pony.Pair;
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
			hash: null,
			units: [],
			cordova: false,
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg: TemplateConfig): Void {
		for (unit in cfg.units) {
			var file: File = cfg.from + unit;
			var content: Null<String> = file.content;
			if (content != null)
				(((cfg.to + unit): File).withoutExt: File).content = replaceVars(content, [
					'title' => cfg.title,
					'hash' => (cfg.hash == null ? '' : cfg.hash.a ? fastHash(cfg.hash.b) : calcHash(cfg.hash.b)),
					'buildDate' => Date.now().toString()
				]);
		}
	}

	private function calcHash(file: File): String {
		var bytes: Null<Bytes> = file.bytes;
		return bytes != null ? Base64.urlEncode(Sha1.make(bytes)) : '';
	}

	private function fastHash(file: File): String {
		var mtime: Null<Date> = file.mtime;
		if (mtime != null) {
			var bo: BytesOutput = new BytesOutput();
			bo.writeInt32(Std.int(mtime.getTime() / 1000));
			return Base64.urlEncode(bo.getBytes());
		} else {
			return '';
		}
	}

	public static function replaceVars(content: String, vars: Map<String, String>): String {
		for (k in vars.keys()) content = @:nullSafety(Off) StringTools.replace(content, '::$k::', vars[k]);
		return content;
	}

}

private typedef TemplateConfig = {
	> types.BAConfig,
	to: String,
	from: String,
	title: String,
	hash: Null<Pair<Bool, String>>,
	units: Array<String>
}

@:nullSafety(Strict) private class TemplateReader extends BAReader<TemplateConfig> {

	override private function clean(): Void {
		cfg.to = '';
		cfg.from = '';
		cfg.title = '';
		cfg.hash = null;
		cfg.units = [];
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'title': cfg.title = normalize(xml.innerData);
			case 'hash': cfg.hash = new Pair(xml.isTrue('fast'), normalize(xml.innerData));
			case 'unit': cfg.units.push(normalize(xml.innerData));
			case _: super.readNode(xml);
		}
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'to': cfg.to = normalize(val);
			case 'from': cfg.from = normalize(val);
			case _:
		}
	}

}