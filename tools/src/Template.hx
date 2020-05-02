import sys.FileSystem;
import sys.io.File;

/**
 * Template
 * @author AxGord <axgord@gmail.com>
 */
class Template {

	private static var TEMPLATE_PATH: String = 'templates/';

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