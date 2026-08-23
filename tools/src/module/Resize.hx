package module;

import format.png.Data;
import format.png.Reader;
import format.png.Tools;
import format.png.Writer;
import haxe.io.Bytes;
import pony.Fast;
import pony.fs.Dir;
import pony.geom.Point;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import types.BASection;

/**
 * Resize module
 * Rewrites images at a smaller pixel size before they are packed. TexturePacker scales a whole
 * sheet and nothing smaller, so art that has to be coarsened otherwise needs an atlas of its own.
 * Nearest neighbour is the only mode on purpose: this is for pixel art, where averaging the
 * palette away is the opposite of what coarsening means. Smooth scaling belongs to the packer.
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Resize extends CfgModule<ResizeConfig> {

	private static inline final PRIORITY: Int = 2;
	private static inline final CHANNELS: Int = 4;
	private static inline final HALF: Float = 0.5;
	private static inline final PNG: String = 'png';

	public function new() super('resize');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new ResizeReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			from: '',
			to: '',
			size: new Point<Int>(0, 0),
			units: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: ResizeConfig): Void {
		for (unit in cfg.units) {
			if (unit.recursive)
				resampleDir(cfg, unit);
			else
				resample(cfg.from + unit.input, cfg.to + unit.output, unit.size);
		}
	}

	/**
	 * Every PNG under a `<dir>`, keeping its path below the directory. Enumerating beats listing
	 * the files: art dropped into the tree is packed either way, where a missed `<unit>` would
	 * leave a region the game asks for and the atlas does not have.
	 */
	private function resampleDir(cfg: ResizeConfig, unit: ResizeUnit): Void {
		final from: String = trimSlash(cfg.from + unit.input);
		final to: String = trimSlash(cfg.to + unit.output);
		final dir: Dir = from;
		if (!dir.exists) {
			error('Directory not found: $from');
			return;
		}
		for (file in dir.contentRecursiveFiles(PNG)) {
			final path: String = file.first.substr(from.length);
			resample(from + path, to + path, unit.size);
		}
	}

	/**
	 * Writes `input` to `output` at `size`. A side left at zero is taken from the other one, so
	 * `w` alone keeps the aspect ratio; both at zero is the one thing there is nothing to do with,
	 * and `error` ends the build rather than leaving the packer to find the file missing.
	 */
	private function resample(input: String, output: String, size: Point<Int>): Void {
		if (size.x <= 0 && size.y <= 0) {
			error('Target size not set for $input');
			return;
		}
		final file: FileInput = File.read(input, true);
		final data: Data = new Reader(file).read();
		file.close();
		final header: Header = Tools.getHeader(data);
		final width: Int = size.x > 0 ? size.x : Math.round(header.width * size.y / header.height);
		final height: Int = size.y > 0 ? size.y : Math.round(header.height * size.x / header.width);
		// A derived side rounds to zero when the image is far from square and the given side is
		// tiny; there is no image to write then, and a zero-sized PNG is worse than stopping.
		if (width <= 0 || height <= 0) {
			error('Target ${width}x$height for $input has an empty side');
			return;
		}
		final pixels: Bytes = Tools.extract32(data);
		log('Resize $input ${header.width}x${header.height} to ${width}x$height');
		final out: Bytes = Bytes.alloc(width * height * CHANNELS);
		// Sampled at the centre of each target pixel, not at its corner: corner sampling never
		// reaches the last source row and column, which slides the whole picture up and left.
		for (y in 0...height) {
			final sourceRow: Int = Std.int((y + HALF) * header.height / height) * header.width;
			for (x in 0...width) {
				final source: Int = sourceRow + Std.int((x + HALF) * header.width / width);
				out.blit((y * width + x) * CHANNELS, pixels, source * CHANNELS, CHANNELS);
			}
		}
		Utils.createPath(output);
		final stream: FileOutput = File.write(output, true);
		new Writer(stream).write(Tools.build32BGRA(width, height, out));
		stream.close();
	}

	private static inline function trimSlash(path: String): String {
		return path.charAt(path.length - 1) == '/' ? path.substr(0, path.length - 1) : path;
	}

}

private typedef ResizeUnit = {
	input: String,
	output: String,
	size: Point<Int>,
	recursive: Bool
}

private typedef ResizeConfig = {
	> types.BAConfig,
	from: String,
	to: String,
	size: Point<Int>,
	units: Array<ResizeUnit>
}

@:nullSafety(Strict) private class ResizeReader extends BAReader<ResizeConfig> {

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
			size: readSize(xml, cfg.size),
			recursive: recursive
		});
	}

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.from = '';
		cfg.to = '';
		cfg.size = new Point<Int>(0, 0);
		cfg.units = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'from': cfg.from += val;
			case 'to': cfg.to += val;
			case 'wh': cfg.size = BAReader.parseWh(val);
			case 'w': cfg.size = new Point<Int>(BAReader.parseSide(val), cfg.size.y);
			case 'h': cfg.size = new Point<Int>(cfg.size.x, BAReader.parseSide(val));
		}
	}

}
