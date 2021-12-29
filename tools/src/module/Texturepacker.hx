package module;

import pony.Fast;
import pony.fs.Dir;
import pony.fs.File;
import pony.geom.Point;
import pony.text.TextTools;

import types.BAConfig;
import types.BASection;

private typedef TPConfig = {
	> BAConfig,
	> TPUnit,
	from: String,
	to: String,
	clean: Bool
}

private typedef TPUnit = {
	format: String,
	scale: Float,
	?datascale: Float,
	quality: Float,
	input: Array<String>,
	output: String,
	?ext: String,
	rotation: Bool,
	?trim: String,
	forceSquared: Bool,
	extrude: UInt,
	alpha: Bool,
	multipack: Bool,
	basicSortBy: String,
	size: Point<Int>,
	pot: Bool,
	padding: UInt
}

/**
 * Texturepacker module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Texturepacker extends CfgModule<TPConfig> {

	private static inline var PRIORITY: Int = 3;

	private var ignoreList: Array<String> = [];
	private var toList: Array<String> = [];
	private var haveClean: Bool = false;

	public function new() super('texturepacker');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new Path(xml, {
			app: ac.app,
			debug: ac.debug,
			before: false,
			section: BASection.Prepare,
			format: 'json png',
			scale: 1,
			quality: 1,
			from: '',
			to: '',
			rotation: true,
			input: [],
			output: null,
			allowCfg: false,
			forceSquared: false,
			extrude: 0,
			padding: 0,
			alpha: true,
			multipack: false,
			basicSortBy: null,
			size: null,
			pot: false,
			clean: false,
			cordova: false
		}, configHandler);
	}

	private function notChanged(key: String, dirs: Array<String>): Bool {
		var hash: Null<module.Hash> = cast modules.getModule(module.Hash);
		return hash != null && hash.xml != null && !hash.dirChanged(key, dirs, '.png');
	}

	override private function runNode(cfg: TPConfig): Void {
		var unit: TPUnit = cfg;
		unit.input = [for (e in cfg.input) cfg.from + e];
		unit.output = cfg.to + cfg.output;
		if (notChanged(cfg.output + '.' + cfg.ext, unit.input)) return;
		if (cfg.clean) haveClean = true;

		var format = unit.format.split(' ');
		@:nullSafety(Off) var f: String = format.shift();

		var licence: Null<String> = Sys.getEnv('TEXTURE_PACKER_LICENCE');
		var first: Bool = true;
		for (s in format) {
			var command = unit.input.copy();

			if (licence != null) {
				command.push('--activate-license');
				command.push(licence);
			}

			command.push('--format');
			command.push(f);

			var outExt = unit.ext != null ? unit.ext : switch f {
				case 'phaser-json-array', 'phaser-json-hash', 'pixijs': 'json';
				case _: f;
			}

			var datafile = unit.output + (first ? '' : '_$s') + '.' + outExt;
			command.push('--data');
			command.push(datafile);

			var tExt: String = s == 'png8' ? 'png' : s;

			var sheetfile = unit.output + '.' + tExt;
			command.push('--sheet');
			command.push(sheetfile);

			if (cfg.clean) {
				ignoreList.push(datafile);
				ignoreList.push(sheetfile);
				toList.push((datafile: File).fullDir);
			}

			if (unit.scale != 1) {
				command.push('--scale');
				command.push(Std.string(unit.scale));

				command.push('--scale-mode');
				command.push('Smooth');
			}

			command.push(unit.rotation ? '--enable-rotation' : '--disable-rotation');

			switch s {
				case 'png', 'png8':
					command.push('--png-opt-level');
					command.push('7');
					if (s == 'png8') {
						command.push('--texture-format');
						command.push('png8');
						command.push('--dither-type');
						command.push('PngQuantHigh');
					}
					if (!unit.alpha) {
						command.push('--opt');
						command.push('RGB888');
					}
				case 'jpg':
					command.push('--jpg-quality');
					command.push(Std.string(Std.int(unit.quality * 100)));
				case _:
			}

			if (unit.forceSquared) command.push('--force-squared');

			if (unit.pot) {
				command.push('--size-constraints');
				command.push('POT');
			}

			if (unit.size != null) {
				if (!unit.pot) {
					command.push('--size-constraints');
					command.push('AnySize');
				}
				command.push('--width');
				command.push('${unit.size.x}');
				command.push('--height');
				command.push('${unit.size.y}');
			}

			command.push('--pack-mode');
			command.push('Best');

			command.push('--extrude');
			command.push('${unit.extrude}');

			command.push('--padding');
			command.push('${unit.padding}');

			if (unit.basicSortBy != null) {
				command.push('--algorithm');
				command.push('Basic');
				command.push('--basic-sort-by');
				command.push(unit.basicSortBy);

			} else {
				command.push('--algorithm');
				command.push('MaxRects');
				command.push('--maxrects-heuristics');
				command.push('Best');
			}

			if (unit.trim != null) {
				var a: Array<String> = unit.trim.split(' ');
				if (a.length == 2) {
					var v: Null<Int> = Std.parseInt(a[0]);
					if (v != null && Std.string(v) == a[0]) {
						command.push('--trim-mode');
						command.push(a[1]);
						command.push('--trim-threshold');
						command.push(Std.string(v));
					} else {
						var v: Null<Int> = Std.parseInt(a[1]);
						command.push('--trim-mode');
						command.push(a[0]);
						if (v != null) {
							command.push('--trim-threshold');
							command.push(Std.string(v));
						}
					}
				} else if (a.length == 1) {
					var v: Null<Int> = Std.parseInt(a[0]);
					if (v != null && Std.string(v) == a[0]) {
						command.push('--trim-mode');
						command.push('Trim');
						command.push('--trim-threshold');
						command.push(Std.string(v));
					} else {
						command.push('--trim-mode');
						command.push(a[0]);
					}
				}
			}

			if (unit.multipack) command.push('--multipack');

			Utils.command('TexturePacker', command, licence != null ? [licence] : null);

			if (unit.datascale != null) {
				switch outExt {
					case 'json':
						pony.text.TextTools.betweenReplaceFile(datafile, '"scale": "', '",', Std.string(unit.datascale));
					case _:
				}
			}

			first = false;
		}
	}

	override private function run(cfg: Array<TPConfig>): Void {
		ignoreList = [];
		toList = [];
		haveClean = false;
		for (e in cfg) runNode(e);
		clean();
		finishCurrentRun();
	}

	private function clean(): Void {
		if (haveClean) {
			var remList: Array<String> = toList.copy();
			for (a in toList) {
				for (b in toList) {
					if (a.length > b.length) {
						if (a.indexOf(b) == 0)
							remList.remove(a);
					}
				}
			}

			log('Clean pathes: ' + remList.join(', '));
			log('Ignores: ' + ignoreList.join(', '));

			for (p in remList) {
				var d: Dir = p;
				for (f in d.contentRecursiveFiles()) {
					if (ignoreList.indexOf(f.first) == -1) {
						log('Delete file: ' + f.first);
						f.delete();
					}
				}
			}

		}
	}

}

private class Path extends BAReader<TPConfig> {

	override private function clean(): Void {
		cfg.format = 'json png';
		cfg.scale = 1;
		cfg.quality = 1;
		cfg.from = '';
		cfg.to = '';
		cfg.rotation = true;
		cfg.input = [];
		cfg.output = null;
		cfg.ext = null;
		cfg.extrude = 0;
		cfg.padding = 0;
		cfg.forceSquared = false;
		cfg.alpha = true;
		cfg.multipack = false;
		cfg.basicSortBy = null;
		cfg.clean = false;
	}

	override private function readXml(xml: Fast): Void {
		var variants: Array<TPConfig> = [for (node in xml.nodes.variant) cast(selfCreate(node), Path).cfg];
		if (variants.length > 0) {
			for (v in variants) {
				cfg = v;
				super.readXml(xml);
			}
		} else {
			super.readXml(xml);
		}
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'format':
				cfg.format = val;
			case 'scale':
				cfg.scale = cfg.scale * Std.parseFloat(val);
			case 'datascale':
				cfg.datascale = Std.parseFloat(val);
			case 'quality':
				cfg.quality = Std.parseFloat(val);
			case 'extrude':
				cfg.extrude = Std.parseInt(val);
			case 'padding':
				cfg.padding = Std.parseInt(val);
			case 'forceSquared':
				cfg.forceSquared = TextTools.isTrue(val);
			case 'from':
				cfg.from += val;
			case 'to':
				cfg.to += val;
			case 'ext':
				cfg.ext = val;
			case 'rotation':
				cfg.rotation = !TextTools.isFalse(val);
			case 'trim':
				cfg.trim = StringTools.trim(val);
			case 'clean':
				cfg.clean = TextTools.isTrue(val);
			case 'alpha':
				cfg.alpha = TextTools.isTrue(val);
			case 'multipack':
				cfg.multipack = TextTools.isTrue(val);
			case 'pot':
				cfg.pot = TextTools.isTrue(val);
			case 'basicSortBy':
				cfg.basicSortBy = normalize(val);
			case 'size':
				var a: Array<Int> = normalize(val).split(' ').map(Std.parseInt);
				cfg.size = a.length == 1 ? new Point(a[0], a[0]) : new Point(a[0], a[1]);
			case _:
		}
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path':
				selfCreate(xml);
			case 'unit':
				new Unit(xml, copyCfg(), onConfig);
			case 'variant':
			case _:
				throw 'Unknown tag';
		}
	}

}

private class Unit extends Path {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path':
				var from = normalize(xml.att.from);
				for (node in xml.nodes.input) {
					cfg.input.push(from + normalize(node.innerData));
				}
			case 'input':
				cfg.input.push(normalize(xml.innerData));
			case 'output':
				cfg.output = normalize(xml.innerData);
			case _:
				throw 'Unknown tag';
		}
	}

	override private function end(): Void onConfig(cfg);

}