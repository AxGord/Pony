package module;

import pony.Fast;
import pony.fs.Dir;
import pony.fs.Unit;
import pony.text.TextTools;

import types.BASection;

/**
 * Clean module
 * @author AxGord <axgord@gmail.com>
 */
@:final class Clean extends CfgModule<CleanConfig> {

	private static inline var PRIORITY: Int = 10;

	public function new() super('clean');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new CleanReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			empty: [],
			units: [],
			keepFiles: [],
			allowCfg: true,
			rimraf: false,
			md: false,
			keepHashed: false,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: CleanConfig): Void {
		var keep: Array<String> = cfg.keepFiles;
		if (cfg.keepHashed) {
			var hashModule: Null<module.Hash> = modules.getModule(module.Hash);
			if (hashModule != null && hashModule.xml != null) {
				var hashed: Array<String> = hashModule.getHashed();
				keep = keep.concat(hashed).concat(hashed.map(function(f: String): String return f + '.bin'));
				if (hashed.length > 1) hashModule.runCleanAfter = true;
			}
		}
		cleanDirs(cfg.dirs, keep, cfg.rimraf, cfg.md);
		deleteUnits(cfg.units);
		cleanEmpty(cfg.empty);
	}

	private function cleanDirs(data: Array<String>, keepFiles: Array<String>, rimraf: Bool, md: Bool): Void {
		for (d in data) {
			var dir: Dir = d;
			if (!dir.exists) {
				if (md) {
					log('Create directory: $d');
					dir.create();
				}
				continue;
			}
			log('Clean directory: $d');
			if (rimraf) {
				Utils.command('rimraf', [d]);
			} else {
				dir.deleteContent(keepFiles);
			}
		}
	}

	private function cleanEmpty(data: Array<String>): Void {
		for (d in data) {
			log('Remove empty directories in $d');
			for (dir in (d: Dir).contentRecursiveDirs()) {
				var content: Array<Unit> = dir.content(true);
				if (content.length == 1 && content[0].name == '.DS_Store') {
					content[0].delete();
					dir.delete();
				} else if (content.length == 0) {
					dir.delete();
				}
			}
		}
	}

	public function deleteUnits(data: Array<String>): Void {
		for (u in data) {
			log('Delete file: $u');
			(u : Unit).delete();
		}
	}

}

private typedef CleanConfig = {
	> types.BAConfig,
	dirs: Array<String>,
	empty: Array<String>,
	units: Array<String>,
	keepFiles: Array<String>,
	rimraf: Bool,
	md: Bool,
	keepHashed: Bool
}

private class CleanReader extends BAReader<CleanConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'dir': cfg.dirs.push(normalize(xml.innerData));
			case 'empty': cfg.empty.push(normalize(xml.innerData));
			case 'unit': cfg.units.push(normalize(xml.innerData));
			case 'keep': cfg.keepFiles.push(normalize(xml.innerData));
			case _: super.readNode(xml);
		}
	}

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.dirs = [];
		cfg.empty = [];
		cfg.units = [];
		cfg.keepFiles = [];
		cfg.rimraf = false;
		cfg.md = false;
		cfg.keepHashed = false;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'rimraf': cfg.rimraf = TextTools.isTrue(val);
			case 'md': cfg.md = TextTools.isTrue(val);
			case 'keepHashed': cfg.keepHashed = TextTools.isTrue(val);
			case _:
		}
	}

}