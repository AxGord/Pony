package module;

import pony.Fast;
import sys.io.File;
import types.BASection;

/**
 * Wrapper module
 * @author AxGord <axgord@gmail.com>
 */
class Wrapper extends CfgModule<WrapperConfig> {

	private static inline var PRIORITY:Int = 4;

	public function new() super('wrapper');

	override public function init():Void initSections(PRIORITY);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new WrapperReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Build,
			file: null,
			pre: '',
			post: '',
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:WrapperConfig):Void {
		var file = cfg.file;
		var pre = cfg.pre;
		var post = cfg.post;
		if (cfg.file != null && (pre != '' || post != '')) {
			Sys.println('Apply wrapper to ' + file);
			var data = File.getContent(file);
			if (pre != null) data = pre + data;
			if (post != null) data = data + post;
			File.saveContent(file, data);
		}
	}

}

private typedef WrapperConfig = { > types.BAConfig,
	pre: String,
	post: String,
	file: String
}

private class WrapperReader extends BAReader<WrapperConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'file':
				cfg.file = StringTools.trim(xml.innerData);
			case 'pre':
				cfg.pre = StringTools.trim(xml.innerData);
			case 'post':
				cfg.post = StringTools.trim(xml.innerData);
			case _:
				super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.file = null;
		cfg.pre = '';
		cfg.post = '';
	}

}