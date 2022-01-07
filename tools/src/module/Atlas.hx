package module;

import pony.Fast;
import pony.fs.Dir;
import pony.fs.File;
import pony.fs.Unit;
import pony.ui.BinaryAtlas;
import pony.ui.BinaryAtlasParams;

import types.BASection;

using StringTools;
using pony.text.TextTools;

private typedef AtlasConfig = {
	> types.BAConfig,
	units: Array<Unit>,
	from: Dir,
	filter: String,
	deleteSource: Bool
}

/**
 * Convert atlases to binary format
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Atlas extends CfgModule<AtlasConfig> {

	private static inline var PRIORITY: Int = 4;
	private static inline var PARAM_DELEMITER: String = ': ';
	private static inline var VALUE_DELEMITER: String = ', ';

	public function new() super('atlas');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new AtlasReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			units: [],
			from: '.',
			filter: '.atlas',
			deleteSource: true,
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: AtlasConfig): Void {
		for (unit in cfg.units) {
			if (unit.isFile) {
				var file: File = unit;
				convert(file, file + '.bin');
				if (cfg.deleteSource) file.delete();
			} else {
				for (file in (unit: Dir).contentRecursiveFiles(cfg.filter)) {
					convert(file, file + '.bin');
					if (cfg.deleteSource) file.delete();
				}
			}
		}
	}

	private function convert(from: File, to: File): Void {
		log('Convert file: $from');
		var data: BinaryAtlas = new BinaryAtlas();
		// https://github.com/HeapsIO/heaps/blob/437697b0847fb5139d485ac768487678a58afa53/hxd/res/Atlas.hx#L56-L135
		var lines: Array<String> = @:nullSafety(Off) from.content.trim().split('\n');
		if (lines.length == 0) error('Atlas empty');
		data.file = @:nullSafety(Off) lines.shift().trim();
		while (lines.length > 0) {
			if (lines[0].indexOf(PARAM_DELEMITER) < 0) break;
			var line: Array<String> = @:nullSafety(Off) lines.shift().trim().split(PARAM_DELEMITER);
			switch line[0] {
				case 'size':
					var wh: Array<String> = line[1].split(',');
					@:nullSafety(Off) data.width = Std.parseInt(wh[0]);
				case _:
			}
		}
		while (lines.length > 0) {
			var line: String = @:nullSafety(Off) lines.shift().trim();
			if (line == '') break;
			var prop: Array<String> = line.split(PARAM_DELEMITER);
			if (prop.length > 1) continue;
			var key: String = line;
			var params: BinaryAtlasParams = new BinaryAtlasParams();
			var index: Int = 0;
			while (lines.length > 0) {
				var line: String = @:nullSafety(Off) lines.shift().trim();
				var prop: Array<String> = line.split(PARAM_DELEMITER);
				if (prop.length == 1) {
					lines.unshift(line);
					break;
				}
				var v: String = prop[1];
				switch prop[0] {
					case 'rotate':
						if (v == 'true') error('Rotation not supported in atlas');
					case 'xy':
						var vals: Array<String> = v.split(VALUE_DELEMITER);
						@:nullSafety(Off) params.x = Std.parseInt(vals[0]);
						@:nullSafety(Off) params.y = Std.parseInt(vals[1]);
					case 'size':
						var vals: Array<String> = v.split(VALUE_DELEMITER);
						@:nullSafety(Off) params.w = Std.parseInt(vals[0]);
						@:nullSafety(Off) params.h = Std.parseInt(vals[1]);
					case 'offset':
						var vals: Array<String> = v.split(VALUE_DELEMITER);
						@:nullSafety(Off) params.dx = Std.parseInt(vals[0]);
						@:nullSafety(Off) params.dy = Std.parseInt(vals[1]);
					case 'orig':
						var vals: Array<String> = v.split(VALUE_DELEMITER);
						@:nullSafety(Off) params.origW = Std.parseInt(vals[0]);
						@:nullSafety(Off) params.origH = Std.parseInt(vals[1]);
					case 'index':
						@:nullSafety(Off) index = Std.parseInt(v);
						if (index < 0) index = 0;
					case _:
						error('Unknown prop ' + prop[0]);
				}
			}
			// offset is bottom-relative
			params.dy = params.origH - (params.h + params.dy);

			var tl: Null<Array<BinaryAtlasParams>> = data.contents[key];
			if (tl == null) {
				tl = [];
				data.contents[key] = tl;
			}
			tl[index] = params;
		}

		// remove first element if index started at 1 instead of 0
		for (tl in data.contents) if (tl.length > 1 && tl[0] == null) tl.shift();

		to.bytes = data.toBytes();
	}

}

private class AtlasReader extends BAReader<AtlasConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path':
				selfCreate(xml);
			case 'unit':
				cfg.units.push(cfg.from.file(normalize(xml.innerData)));
			case _:
				super.readNode(xml);
		}
	}

	override private function clean(): Void {
		cfg.units = [];
		cfg.filter = '.atlas';
		cfg.from = '.';
		cfg.deleteSource = true;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'filter': cfg.filter = val;
			case 'from': cfg.from += val;
			case 'deleteSource': cfg.deleteSource = !val.isFalse();
			case _:
		}
	}

}