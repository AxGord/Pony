import sys.FileSystem;
import sys.io.File;

using StringTools;

/**
 * Template
 * @author AxGord <axgord@gmail.com>
 */
class Template {

	private static final TEMPLATE_PATH: String = 'templates/';

	public static function gen(path: String, files: Map<String, String>, vars: Map<String, String>): Void {
		path = Utils.toolsPath + TEMPLATE_PATH + path;
		for (file => value in files) {
			final out: String = replaceVars(value, vars);
			if (FileSystem.exists(out)) {
				Sys.println('File exists, skip: $out');
			} else {
				Sys.println('Generate: $out');
				final index: Int = out.lastIndexOf('/');
				if (index != -1) {
					final p: String = out.substr(0, index);
					if (!FileSystem.exists(p)) FileSystem.createDirectory(p);
				}
				File.saveContent(out, replaceVars(File.getContent(path + file), vars));
			}
		}
	}

	public static function replaceVars(content: String, vars: Map<String, String>): String {
		for (k => value in vars) content = content.replace('::$k::', value);
		return content;
	}

}
