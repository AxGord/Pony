import pony.Pair;
import pony.fs.Dir;

/**
 * Lines
 * @author AxGord <axgord@gmail.com>
 */
class Lines {

	public static function run(): Void {
		tryShow('Haxe', '.hx');
		tryShow('Xml', '.xml');
		tryShow('Json', '.json');
		tryShow('JavaScript', '.js');
		tryShow('TypeScript', '.ts');
		tryShow('ActionScript3', '.as');
		tryShow('MXML', '.mxml');
	}

	private static function tryShow(lang: String, ext: String): Void {
		final p: Pair<Int, Int> = getCount(ext);
		if (p.b > 0) Sys.println('$lang files total lines count: ${p.a} in ${p.b} files');
	}

	private static function getCount(ext: String): Pair<Int, Int> {
		var count: Int = 0;
		var files: Int = 0;
		for (file in ('.': Dir).contentRecursiveFiles(ext)) {
			files++;
			count += file.content.split('\n').length;
		}
		return new Pair(count, files);
	}

}
