package module;

import format.png.Data;
import format.png.Reader;
import format.png.Tools;
import format.png.Writer;
import haxe.io.Bytes;
import pony.Fast;
import pony.color.UColor;
import pony.geom.Point;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import types.BASection;

/**
 * Spritesheet module
 * Cuts uniform grid spritesheets into numbered frames, so a packer that only accepts
 * single-sprite files can still consume them.
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Spritesheet extends CfgModule<SpritesheetConfig> {

	private static inline final PRIORITY: Int = 2;
	private static inline final CHANNELS: Int = 4;

	public function new() super('spritesheet');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new SpritesheetReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			from: '',
			to: '',
			size: new Point<Int>(0, 0),
			count: 0,
			colorKey: null,
			units: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: SpritesheetConfig): Void {
		for (unit in cfg.units) cut(cfg.from + unit.input, cfg.to + unit.output, unit);
	}

	private function cut(input: String, output: String, unit: SpritesheetUnit): Void {
		final size: Point<Int> = unit.size;
		if (size.x <= 0 || size.y <= 0) {
			error('Cell size not set for $input');
			return;
		}
		final file: FileInput = File.read(input, true);
		final data: Data = new Reader(file).read();
		file.close();
		final header: Header = Tools.getHeader(data);
		if (header.width < size.x || header.height < size.y) {
			error('Cell ${size.x}x${size.y} is bigger than sheet $input (${header.width}x${header.height})');
			return;
		}
		final pixels: Bytes = Tools.extract32(data);
		if (unit.colorKey != null) eraseColor(pixels, unit.colorKey);
		final columns: Int = Std.int(header.width / size.x);
		final frames: Int = unit.count > 0 ? unit.count : columns * Std.int(header.height / size.y);
		log('Cut $input into $frames frames ${size.x}x${size.y}');
		Utils.createPath(output);
		final lineSize: Int = size.x * CHANNELS;
		for (i in 0...frames) {
			final left: Int = i % columns * size.x;
			final top: Int = Std.int(i / columns) * size.y;
			final frame: Bytes = Bytes.alloc(lineSize * size.y);
			for (y in 0...size.y) frame.blit(y * lineSize, pixels, ((top + y) * header.width + left) * CHANNELS, lineSize);
			final out: FileOutput = File.write('${output}_$i.png', true);
			new Writer(out).write(Tools.build32BGRA(size.x, size.y, frame));
			out.close();
		}
	}

	/**
	 * Makes every pixel of the given color fully transparent, in place.
	 * Sheets drawn on a flat backdrop instead of an alpha channel need this before packing.
	 */
	private function eraseColor(pixels: Bytes, color: UColor): Void {
		final blue: Int = color.b;
		final green: Int = color.g;
		final red: Int = color.r;
		var i: Int = 0;
		while (i < pixels.length) {
			if (pixels.get(i) == blue && pixels.get(i + 1) == green && pixels.get(i + 2) == red) pixels.fill(i, CHANNELS, 0);
			i += CHANNELS;
		}
	}

}

private typedef SpritesheetUnit = {
	input: String,
	output: String,
	size: Point<Int>,
	count: Int,
	colorKey: Null<UColor>
}

private typedef SpritesheetConfig = {
	> types.BAConfig,
	from: String,
	to: String,
	size: Point<Int>,
	count: Int,
	colorKey: Null<UColor>,
	units: Array<SpritesheetUnit>
}

@:nullSafety(Strict) private class SpritesheetReader extends BAReader<SpritesheetConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'unit': cfg.units.push({
				input: normalize(xml.innerData),
				output: xml.has.to ? normalize(xml.att.to) : normalize(xml.innerData),
				size: readSize(xml, cfg.size),
				count: xml.has.count ? BAReader.parseSide(normalize(xml.att.count)) : cfg.count,
				colorKey: xml.has.colorKey ? normalize(xml.att.colorKey) : cfg.colorKey
			});
			case _: super.readNode(xml);
		}
	}

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.from = '';
		cfg.to = '';
		cfg.size = new Point<Int>(0, 0);
		cfg.count = 0;
		cfg.colorKey = null;
		cfg.units = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'from': cfg.from += val;
			case 'to': cfg.to += val;
			case 'wh': cfg.size = BAReader.parseWh(val);
			case 'w': cfg.size = new Point<Int>(BAReader.parseSide(val), cfg.size.y);
			case 'h': cfg.size = new Point<Int>(cfg.size.x, BAReader.parseSide(val));
			case 'count': cfg.count = BAReader.parseSide(val);
			case 'colorKey': cfg.colorKey = val;
		}
	}

}
