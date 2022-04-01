package module;

import sys.FileSystem;
import pony.time.Time;
import haxe.io.Eof;
import sys.io.Process;
import pony.Fast;
import pony.Pair;
import pony.fs.Dir;
import pony.fs.File;
import pony.fs.Unit;

import types.BASection;

using pony.text.TextTools;
using StringTools;

/**
 * Shntool module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Shntool extends CfgModule<ShntoolConfig> {

	private static inline var PRIORITY: Int = 23;

	public function new() super('shntool');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new ShntoolReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			wav: [],
			to: '',
			from: '',
			addext: '',
			hash: false,
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: ShntoolConfig): Void {
		for (wav in cfg.wav) {
			var files: Array<String> = [];
			for (d in wav.dirs) {
				var dir: Dir = cfg.from + d.a;
				var filter: Null<String> = d.b;
				log('Shntool directory: $dir');
				for (f in dir.contentRecursiveFiles(filter)) files.push(f.first);
			}
			for (u in wav.units) {
				var unit: Unit = cfg.from + u;
				log('Shntool file: $unit');
				if (unit.isFile) {
					files.push(unit.first);
				} else {
					error('Is not file!');
				}
			}
			var process: Process = new Process('shntool', ['join', '-O', 'always'].concat(files));
			if (process.exitCode() != 0) {
				try {
					while (true) log(process.stderr.readLine());
				} catch (e: Eof) {}
				error('Shntool error');
			}
			if (wav.cue != null) {
				var result: String = 'FILE "${wav.output}" WAVE\n';
				try {
					var time: Time = 0;
					var index: UInt = 0;
					while (true) {
						var s: String = process.stderr.readLine();
						if (s == null || !s.startsWith('Joining [')) break;
						s = s.substr(9, s.indexOf(') --> [', 9) - 9);
						if (s == '') break;
						var a: Array<String> = s.split('] (');
						if (a.length != 2) break;
						var name: String = a[0].substr(cfg.from.length);
						name = name.substr(0, -4);
						if (name == '') break;
						result += '\tTRACK $index AUDIO\n';
						result += '\t\tTITLE "${name}"\n';
						result += '\t\tINDEX 01 ${time.toString()}\n';
						time += Time.fromString(a[1]);
						index++;
					}
				} catch (e: Eof) {}
				@:nullSafety(Off) (wav.cue: File).content = result;
			}
			FileSystem.rename('joined.wav', cfg.to + wav.output);
			log(cfg.to + wav.output + ' - created');
		}
	}

}

private typedef ShntoolConfig = {
	> types.BAConfig,
	from: String,
	to: String,
	wav: Array<WavConfig>,
	hash: Bool,
	addext: String
}

private typedef WavConfig = {
	> types.BAConfig,
	output: String,
	cue: Null<String>,
	dirs: Array<Pair<String, Null<String>>>,
	units: Array<String>
}

@:nullSafety(Strict) private class ShntoolReader extends BAReader<ShntoolConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'wav':
				new WavReader(xml, {
					debug: cfg.debug,
					app: cfg.app,
					before: cfg.before,
					section: cfg.section,
					allowCfg: true,
					cordova: false,
					output: 'sounds.wav',
					cue: null,
					dirs: [],
					units: []
				}, wavConfigHandler);
			case _: super.readNode(xml);
		}
	}

	private function wavConfigHandler(wav: WavConfig): Void {
		cfg.wav.push(wav);
	}

	override private function clean(): Void {
		cfg.wav = [];
		cfg.to = '';
		cfg.from = '';
		cfg.hash = false;
		cfg.addext = '';
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'to': cfg.to += val;
			case 'from': cfg.from += val;
			case 'hash': cfg.hash = val.isTrue();
			case 'addext': cfg.addext = val;
			case _:
		}
	}

}

@:nullSafety(Strict) private class WavReader extends BAReader<WavConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'dir': cfg.dirs.push(new Pair(normalize(xml.innerData), xml.has.filter ? normalize(xml.att.filter) : '.wav'));
			case 'unit': cfg.units.push(normalize(xml.innerData));
			case _: super.readNode(xml);
		}
	}

	override private function clean(): Void {
		cfg.dirs = [];
		cfg.units = [];
		cfg.output = 'sounds.wav';
		cfg.cue = null;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'output': cfg.output = val;
			case 'cue': cfg.cue = val;
			case _:
		}
	}

}