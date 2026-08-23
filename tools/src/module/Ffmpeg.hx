package module;

import pony.Fast;
import pony.fs.Dir;
import pony.fs.File;
import pony.fs.Unit;
import types.BASection;

/**
 * Ffmpeg module
 * Converts media by handing it to ffmpeg, which is the whole reason it exists beside `<lame>` and
 * `<oggenc>`: those drive encoders that read wav and nothing else, so a source kept in a lossless
 * container — flac, aiff, a movie's audio track — has no way through them at all. Here the target
 * format is named by `ext` alone and ffmpeg picks the encoder from it, so one block writes mp3,
 * ogg or wav and switching between them is one attribute.
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Ffmpeg extends CfgModule<FfmpegConfig> {

	/** The format written when `ext` is not given. */
	public static inline final DEFAULT_EXT: String = 'mp3';

	/** `q` left at this is kept off the command line: not every encoder has a quality scale. */
	public static inline final NO_QUALITY: Int = -1;

	private static inline final PRIORITY: Int = 24;

	public function new() super('ffmpeg');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new FfmpegReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			from: '',
			to: '',
			ext: DEFAULT_EXT,
			quality: NO_QUALITY,
			af: null,
			units: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: FfmpegConfig): Void {
		for (unit in cfg.units) {
			if (unit.recursive)
				convertDir(cfg, unit);
			else
				convertUnit(cfg, unit);
		}
	}

	/**
	 * Every matching file under a `<dir>`, keeping its path below the directory. `filter` is a
	 * plain suffix, so the dot in `.flac` is what keeps a file named `weirdflac` out. Enumerating
	 * beats listing the files one by one: a source dropped into the tree is converted either way,
	 * where a missed `<unit>` leaves an asset the game asks for and the build never wrote.
	 */
	private function convertDir(cfg: FfmpegConfig, unit: FfmpegUnit): Void {
		final from: String = trimSlash(cfg.from + unit.input);
		final to: String = trimSlash(cfg.to + unit.output);
		final dir: Dir = from;
		if (!dir.exists) {
			error('Directory not found: $from');
			return;
		}
		final files: Array<File> = dir.contentRecursiveFiles(unit.filter);
		if (files.length == 0) {
			error(unit.filter == null ? 'No files under $from' : 'No "${unit.filter}" files under $from');
			return;
		}
		// Cut to a path relative to the walked root, so an empty `to` writes beside the sources
		// instead of at the filesystem root.
		final cut: Int = from == '' ? 0 : from.length + 1;
		for (file in files) convert(file.first, join(to, replaceExt(file.first.substr(cut), cfg.ext)), cfg.quality, unit.af);
	}

	private function convertUnit(cfg: FfmpegConfig, unit: FfmpegUnit): Void {
		final source: Unit = cfg.from + unit.input;
		if (!source.isFile) {
			error('File not found: ${cfg.from}${unit.input}');
			return;
		}
		convert(source.first, cfg.to + replaceExt(unit.output, cfg.ext), cfg.quality, unit.af);
	}

	/**
	 * One file through ffmpeg. `-y` because a prepare that has already run leaves the output
	 * sitting there and the prompt would hang the build; `-v error` because ffmpeg prints its
	 * whole build banner on every invocation, and a directory of them buries the log.
	 */
	private function convert(input: String, output: String, quality: Int, af: Null<String>): Void {
		log('Ffmpeg $input to $output');
		Utils.createPath(output);
		final args: Array<String> = ['-v', 'error', '-y', '-i', input];
		if (af != null) {
			args.push('-af');
			args.push(af);
		}
		if (quality != NO_QUALITY) {
			args.push('-q:a');
			args.push('$quality');
		}
		args.push(output);
		Utils.command('ffmpeg', args);
	}

	/**
	 * The output name: whatever follows the last dot replaced, and an extension appended when the
	 * name has none. Cutting a fixed number of characters instead — which is what `<lame>` and
	 * `<oggenc>` do, three for wav — folds the tail of a longer extension into the new one, so
	 * `main.flac` comes out as `main.flmp3`.
	 */
	private static inline function replaceExt(path: String, ext: String): String {
		// A dot inside a directory name is not this file's extension.
		final dot: Int = path.lastIndexOf('.');
		return dot > path.lastIndexOf('/') ? '${path.substr(0, dot + 1)}$ext' : '$path.$ext';
	}

	private static inline function trimSlash(path: String): String {
		return path.charAt(path.length - 1) == '/' ? path.substr(0, path.length - 1) : path;
	}

	private static inline function join(dir: String, path: String): String return dir == '' ? path : '$dir/$path';

}

private typedef FfmpegUnit = {
	input: String,
	output: String,
	filter: Null<String>,
	af: Null<String>,
	recursive: Bool
}

private typedef FfmpegConfig = {
	> types.BAConfig,
	from: String,
	to: String,
	ext: String,
	quality: Int,
	af: Null<String>,
	units: Array<FfmpegUnit>
}

@:nullSafety(Strict) private class FfmpegReader extends BAReader<FfmpegConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'unit': addUnit(xml, false);
			case 'dir': addUnit(xml, true);
			case _: super.readNode(xml);
		}
	}

	private function addUnit(xml: Fast, recursive: Bool): Void {
		final input: String = normalize(xml.innerData);
		cfg.units.push({
			input: input,
			output: xml.has.to ? normalize(xml.att.to) : input,
			filter: xml.has.filter ? normalize(xml.att.filter) : null,
			af: xml.has.af ? normalize(xml.att.af) : cfg.af,
			recursive: recursive
		});
	}

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.from = '';
		cfg.to = '';
		cfg.ext = Ffmpeg.DEFAULT_EXT;
		cfg.quality = Ffmpeg.NO_QUALITY;
		cfg.af = null;
		cfg.units = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'from': cfg.from += val;
			case 'to': cfg.to += val;
			case 'ext': cfg.ext = val;
			case 'q': cfg.quality = parseQuality(val);
			case 'af': cfg.af = val;
		}
	}

	/**
	 * The throw surfaces with no XML around it, so naming the attribute is what tells the reader
	 * which knob in pony.xml to look at — the same shape `BAReader` uses for a bad size.
	 */
	private static function parseQuality(val: String): Int {
		final v: Null<Int> = Std.parseInt(val);
		if (v == null) throw 'Bad q: "$val"';
		return v;
	}

}
