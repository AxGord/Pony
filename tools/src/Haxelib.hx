import sys.FileSystem;

using StringTools;

/**
 * Haxelib
 * @author AxGord <axgord@gmail.com>
 */
class Haxelib {

	private static inline final listFile: String = 'haxelibfiles.txt';
	private static inline final outputFile: String = 'haxelib.zip';
	private static inline final haxelibFile: String = 'haxelib.json';
	private static inline final readmeFile: String = 'README.md';
	private static inline final badgeVersionBegin: String = '[![Haxelib](https://img.shields.io/badge/haxelib-';
	private static inline final badgeVersionEnd: String = '-';

	public static function run(command: String, args: Array<String>): Void {
		switch command {
			case 'submit':
				final a: Null<String> = args.shift();
				submit(a, args.join(' '));
			case 'create':
				final a: Null<String> = args.shift();
				create(a, args.join(' '));
			case 'micro':
				upver(2, args.join(' '));
			case 'minor':
				upver(1, args.join(' '));
			case 'major':
				upver(0, args.join(' '));
			case 'updateReadme':
				updateReadme(getVersion());
			case 'upload':
				upload();
			case _:
				Utils.error('Unknown command');
		}
	}

	public static function submit(version: String, desc: String): Void {
		if (version == null) {
			Utils.error('Please, set version');
			return;
		}

		final jdata = getData();

		if (jdata.version == version) {
			Utils.error('Wrong new version');
			return;
		}

		final oldver: Array<Int> = parseVersion(jdata.version);
		final newver: Array<Int> = parseVersion(version);

		if (!(newver[0] > oldver[0] || newver[1] > oldver[1] || newver[2] > oldver[2])) {
			Utils.error('Wrong new version');
			return;
		}

		_submit(jdata, version, desc);
	}

	public static function create(name: String, author: String): Void {
		if (name == null) {
			Utils.error('Please, set lib name (first arg)');
			return;
		}
		if (author == null) {
			Utils.error('Please, set lib author (second arg)');
			return;
		}
		if (libexists()) {
			Utils.error('$haxelibFile exists');
			return;
		}
		final jdata = { name: name, url: '', license: '', tags: [], description: '', version: '0.0.1', releasenote: 'Init', contributors: [author], dependencies: {} };
		saveJson(jdata);
		Sys.println('Library $name created');
	}

	private static inline function updateReadme(version: String): Void {
		pony.text.TextTools.betweenReplaceFile(readmeFile, badgeVersionBegin, badgeVersionEnd, version);
	}

	private static inline function libexists(): Bool return FileSystem.exists(haxelibFile);

	private static inline function saveJson(jdata: Dynamic): Void Utils.saveJson(haxelibFile, jdata);

	private static function upver(index: Int, desc: String): Void {
		final jdata = getData();
		final ver: Array<Int> = parseVersion(jdata.version);
		ver[index]++;
		for (i in index + 1...ver.length) ver[i] = 0;
		_submit(jdata, ver.join('.'), desc);
	}

	private static function getData(): Dynamic {
		if (!libexists()) {
			Utils.error('$haxelibFile not exists');
			return null;
		}
		final tdata: String = sys.io.File.getContent(haxelibFile);
		return haxe.Json.parse(tdata);
	}

	private static function getVersion(): String return getData().version;

	private static function _submit(jdata: Dynamic, version: String, desc: String): Void {
		updateReadme(version);
		if (desc == null) desc = '';
		jdata.version = version;
		jdata.releasenote = desc;
		saveJson(jdata);
		upload();
		git(version, desc);
	}

	private static function upload(): Void {
		final data: Array<String> = sys.io.File.getContent(listFile).split('\n');
		if (data.indexOf(haxelibFile) == -1) data.push(haxelibFile);
		final zip: pony.ZipTool = new pony.ZipTool(outputFile, 0);
		zip.onLog << Sys.println;
		zip.onError << function(err: String) throw err;
		zip.writeList(data).end();

		Sys.command('haxelib', ['submit', outputFile]);
		FileSystem.deleteFile(outputFile);
	}

	private static function git(version: String, desc: String): Void {
		if (!FileSystem.exists('.git')) return;
		try {
			final message: String = 'Update haxelib v $version. $desc'.rtrim();
			Utils.command('git', ['add', '--all']);
			Utils.command('git', ['commit', '-a', '-m', message]);
			Utils.command('git', ['push']);
		} catch (e: Dynamic) {}
	}

	private static function parseVersion(s: String): Array<Int> return s.split('.').map(Std.parseInt);

}
