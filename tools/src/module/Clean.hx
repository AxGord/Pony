package module;

import pony.text.TextTools;
import pony.Fast;
import pony.fs.Unit;
import pony.fs.Dir;
import types.BASection;

/**
 * Clean module
 * @author AxGord <axgord@gmail.com>
 */
@:final class Clean extends CfgModule<CleanConfig> {

	private static inline var PRIORITY: Int = 10;

	public function new() super('clean');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new CleanReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			empty: [],
			units: [],
			allowCfg: true,
			rimraf: false,
			md: false
		}, configHandler);
	}

	override private function runNode(cfg: CleanConfig): Void {
		cleanDirs(cfg.dirs, cfg.rimraf, cfg.md);
		deleteUnits(cfg.units);
		cleanEmpty(cfg.empty);
	}

	private function cleanDirs(data: Array<String>, rimraf: Bool, md: Bool): Void {
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
				dir.deleteContent();
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

	private function deleteUnits(data: Array<String>): Void {
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
	rimraf: Bool,
	md: Bool
}

private class CleanReader extends BAReader<CleanConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'dir': cfg.dirs.push(StringTools.trim(xml.innerData));
			case 'empty': cfg.empty.push(StringTools.trim(xml.innerData));
			case 'unit': cfg.units.push(StringTools.trim(xml.innerData));
			case _: super.readNode(xml);
		}
	}

	override private function clean(): Void {
		cfg.dirs = [];
		cfg.empty = [];
		cfg.units = [];
		cfg.rimraf = false;
		cfg.md = false;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'rimraf': cfg.rimraf = TextTools.isTrue(val);
			case 'md': cfg.md = TextTools.isTrue(val);
			case _:
		}
	}

}