/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package module;

import haxe.xml.Fast;
import haxe.crypto.Crc32;
import sys.io.File;
import sys.FileSystem;
import pony.fs.Dir;
import pony.Pair;
import pony.SPair;
import pony.ThreadTasks;
import types.BASection;

private typedef HashTargets = Pair<SPair<String>, Array<String>>;

/**
 * Hash module
 * @author AxGord <axgord@gmail.com>
 */
class Hash extends Module {
	
	private static inline var PRIORITY:Int = 8;

	private var map:Map<String, String>;

	private var beforeDirs:Map<BASection, HashTargets> = new Map();
	private var beforeUnits:Map<BASection, HashTargets> = new Map();
	private var afterDirs:Map<BASection, HashTargets> = new Map();
	private var afterUnits:Map<BASection, HashTargets> = new Map();

	private var threads:Int = 1;
	private var hash:Bool = false;

	public function new() super('hash');

	override public function init():Void {
		if (xml == null) return;
		if (xml.has.threads) threads = Std.parseInt(xml.att.threads);
		hash = pony.text.XmlTools.isTrue(xml, 'hash');
		addConfigListener();
		addListeners(PRIORITY, before, after);
		modules.commands.onHash < start;
	}

	override private function readConfig(ac:AppCfg):Void {
		new HashReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Hash,
			dirs: [],
			units: [],
			stateFile: 'hashstate.txt',
			changesFile: 'hashchanges.txt'
		}, configHandler);
	}

	private function start():Void {
		if (!afterDirs.exists(BASection.Hash) && !afterUnits.exists(BASection.Hash)) return;
		if (afterDirs.exists(BASection.Hash)) dirs(afterDirs[BASection.Hash]);
		if (afterUnits.exists(BASection.Hash)) units(afterUnits[BASection.Hash]);
	}

	private function before(section:BASection):Void {
		if (section == BASection.Hash) return;
		if (!beforeDirs.exists(section) && !beforeUnits.exists(section)) return;
		//todo: look files
		if (beforeDirs.exists(section)) dirs(beforeDirs[section]);
		if (beforeUnits.exists(section)) units(beforeUnits[section]);
	}

	private function after(section:BASection):Void {
		if (section == BASection.Hash) return;
		if (!afterDirs.exists(section) && !afterUnits.exists(section)) return;
		if (afterDirs.exists(section)) dirs(afterDirs[section]);
		if (afterUnits.exists(section)) units(afterUnits[section]);
	}

	private function dirs(data:HashTargets):Void {
		var list:Array<String> = [];
		for (e in data.b) {
			var d:Dir = e;
			for (f in d.contentRecursiveFiles())
				list.push(f);
		}
		files(data.a, list);
	}

	private function units(data:HashTargets):Void {
		files(data.a, data.b);
	}

	private function files(file:SPair<String>, list:Array<String>):Void {
		var map:Map<String, Array<String>> = getMap(file.a);
		var nmap:Map<String, Array<String>> = new Map();
		var changesMap:Map<String, Array<String>> = new Map();
		Sys.println('Hashing');
		ThreadTasks.multyTask(threads, function(){
			while (list.length > 0) {
				var e = list.pop();
				var stat = FileSystem.stat(e);
				var nt = Std.string(stat.mtime.getTime());
				var ns = Std.string(stat.size);
				if (!map.exists(e) || nt != map[e][0] || ns != map[e][1]) {
					if (hash) {
						var nHash = Std.string(Crc32.make(File.getBytes(e)));
						var nd = [nt, ns, nHash];
						if (map[e][2] != nHash) {
							changesMap[e] = nd;
							Sys.print('!');
						} else {
							Sys.print('.');
						}
						nmap[e] = nd;
					} else {
						var nd = [nt, ns];
						changesMap[e] = nd;
						nmap[e] = nd;
						Sys.print('!');
					}
				} else {
					nmap[e] = map[e];
					Sys.print('.');
				}
			}
		});
		saveMap(file.a, nmap);
		saveMap(file.b, changesMap);
		Sys.println('');
		Sys.println('Hashing complete');
	}

	private function getMap(file:String):Map<String, Array<String>> {
		var c = FileSystem.exists(file) ? File.getContent(file) : '';
		var m = new Map<String, Array<String>>();
		for (e in c.split('\n')) {
			var a = e.split(':');
			if (a.length > 1)
				m[a[0]] = a[1].split(',');
		}
		return m;
	}

	private function saveMap(file:String, map:Map<String, Array<String>>):Void {
		File.saveContent(file, [for (k in map.keys()) k + ':' + map[k].join(',')].join('\n'));

	}

	private function configHandler(cfg:HashConfig):Void {
		var filesPair = new SPair(cfg.stateFile, cfg.changesFile);
		if (cfg.before) {
			if (cfg.dirs.length > 0) {
				if (beforeDirs.exists(cfg.section)) {
					beforeDirs[cfg.section].b = beforeDirs[cfg.section].b.concat(cfg.dirs);
				} else {
					beforeDirs[cfg.section] = new Pair(filesPair, cfg.dirs);
				}
			}
			if (cfg.units.length > 0) {
				if (beforeUnits.exists(cfg.section)) {
					beforeUnits[cfg.section].b = beforeUnits[cfg.section].b.concat(cfg.units);
				} else {
					beforeUnits[cfg.section] = new Pair(filesPair, cfg.units);
				}
			}
		} else {
			if (cfg.dirs.length > 0) {
				if (afterDirs.exists(cfg.section)) {
					afterDirs[cfg.section].b = afterDirs[cfg.section].b.concat(cfg.dirs);
				} else {
					afterDirs[cfg.section] = new Pair(filesPair, cfg.dirs);
				}
			}
			if (cfg.units.length > 0) {
				if (afterUnits.exists(cfg.section)) {
					afterUnits[cfg.section].b = afterUnits[cfg.section].b.concat(cfg.units);
				} else {
					afterUnits[cfg.section] = new Pair(filesPair, cfg.units);
				}
			}
		}
	}

}

private typedef HashConfig = { > types.BAConfig,
	dirs: Array<String>,
	units: Array<String>,
	stateFile: String,
	changesFile: String
}

private class HashReader extends BAReader<HashConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'dir': cfg.dirs.push(StringTools.trim(xml.innerData));
			case 'unit': cfg.units.push(StringTools.trim(xml.innerData));

			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.dirs = [];
		cfg.units = [];
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'state': cfg.stateFile = val;
			case 'changes': cfg.changesFile = val;
			case _:
		}
	}

}