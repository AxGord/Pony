/**
 * Generate
 * @author AxGord <axgord@gmail.com>
 */

import sys.FileSystem;
import sys.io.File;

class Generate {

	private static var TEMPLATE_PATH: String = 'templates/';
	private static var WEB_PAGES_PATH: String = 'bin/home/templates/Default/pages/';
	private static var WEB_MODELS_PATH: String = 'src/models/';
	private static var WEB_MODEL_TEMPLATE_PATH: String = 'webmodel/';

	public static function run(type: String, name: String): Void {
		if (name == null) Utils.error('Name not set');
		switch type {
			case 'webmodels', 'web', 'w':
				genWebModule(name);
			case _:
				Utils.error('Unknown type');
		}
	}

	private static function genWebModule(name: String): Void {
		gen(WEB_MODEL_TEMPLATE_PATH, [
			'Model.hx' => '$WEB_MODELS_PATH::NAME::.hx',
			'Template.tpl' => '$WEB_PAGES_PATH::name::.tpl',
			'RMTemplate.tpl' => '${WEB_PAGES_PATH}rm::name::.tpl',
		], [
			'NAME' => name,
			'name' => name.toLowerCase()
		]);
	}

	public static function gen(path: String, files: Map<String, String>, vars: Map<String, String>): Void {
		path = Utils.toolsPath + TEMPLATE_PATH + path;
		for (file in files.keys()) {
			var out: String = replaceVars(files[file], vars);
			if (FileSystem.exists(out)) {
				Sys.println('File exists, skip: $out');
			} else {
				Sys.println('Generate: $out');
				File.saveContent(out, replaceVars(File.getContent(path + file), vars));
			}
		}
	}

	public static function replaceVars(content: String, vars: Map<String, String>): String {
		for (k in vars.keys()) content = StringTools.replace(content, '::$k::', vars[k]);
		return content;
	}

}
