package module;

import pony.Fast;

import types.BASection;

/**
 * Url module
 * @author AxGord <axgord@gmail.com>
 */
class Url extends CfgModule<UrlConfig> {

	private static inline var PRIORITY: Int = 25;

	public function new() super('url');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Build);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new UrlReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Build,
			url: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: UrlConfig): Void {
		for (u in cfg.url) url(u);
	}

	private function url(u: String): Void {
		log('Http request: $u');
		log(haxe.Http.requestUrl(u));
	}

}

private typedef UrlConfig = {
	> types.BAConfig,
	url: Array<String>
}

private class UrlReader extends BAReader<UrlConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'url': cfg.url.push(StringTools.trim(xml.innerData));
			case _: super.readNode(xml);
		}
	}

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.url = [];
	}

}