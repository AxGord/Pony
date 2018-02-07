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

private typedef CalcConfig = {a: String, b: String, c: String, r:String};

/**
 * Hash module
 * @author AxGord <axgord@gmail.com>
 */
class Hash extends Module {
	
	private static inline var PRIORITY:Int = 8;

	public var ignore:Array<String> = [];

	private var map:Map<String, String>;

	private var beforeDirs:Map<BASection, HashTargets> = new Map();
	private var beforeUnits:Map<BASection, HashTargets> = new Map();
	private var beforeCalc:Map<BASection, CalcConfig> = new Map();
	private var afterDirs:Map<BASection, HashTargets> = new Map();
	private var afterUnits:Map<BASection, HashTargets> = new Map();
	private var afterCalc:Map<BASection, CalcConfig> = new Map();

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
			calc: createCalcConfig(),
			stateFile: 'hashstate.txt',
			changesFile: null//'hashchanges.txt'
		}, configHandler);
	}

	private function start():Void {
		if (afterCalc.exists(BASection.Hash)) {
			var ac = afterCalc[BASection.Hash];
			calc(ac.a, ac.b, ac.c, ac.r);
		}
		if (!afterDirs.exists(BASection.Hash) && !afterUnits.exists(BASection.Hash)) return;
		if (afterDirs.exists(BASection.Hash)) dirs(afterDirs[BASection.Hash]);
		if (afterUnits.exists(BASection.Hash)) units(afterUnits[BASection.Hash]);
	}

	private function before(section:BASection):Void {
		if (section == BASection.Hash) return;
		if (beforeCalc.exists(section)) calc(beforeCalc[section].a, beforeCalc[section].b, beforeCalc[section].c, beforeCalc[section].r);
		if (!beforeDirs.exists(section) && !beforeUnits.exists(section)) return;
		//todo: look files
		if (beforeDirs.exists(section)) dirs(beforeDirs[section]);
		if (beforeUnits.exists(section)) units(beforeUnits[section]);
	}

	private function after(section:BASection):Void {
		if (section == BASection.Hash) return;
		if (afterCalc.exists(section)) calc(afterCalc[section].a, afterCalc[section].b, afterCalc[section].c, afterCalc[section].r);
		if (!afterDirs.exists(section) && !afterUnits.exists(section)) return;
		if (afterDirs.exists(section)) dirs(afterDirs[section]);
		if (afterUnits.exists(section)) units(afterUnits[section]);
	}

	private function dirs(data:HashTargets):Void {
		var list:Array<String> = [];
		for (e in data.b) {
			var d:Dir = e;
			for (f in d.contentRecursiveFiles())
				if (f.name.charAt(0) != '.' && ignore.indexOf(f.name) == -1) list.push(f);
		}
		files(data.a, list);
	}

	private function units(data:HashTargets):Void {
		files(data.a, data.b);
	}

	private function calc(a:String, b:String, c:String, r:String):Void {
		var ah = Utils.getHashes(a);
		var bh = Utils.getHashes(b);
		var ch:Map<String, Array<String>> = new Map();
		var rm:Array<String> = [];
		for (ak in ah.keys()) {
			if (!(bh.exists(ak) && compareHash(ah[ak], bh[ak]))) {
				ch[ak] = ah[ak];
			}
		}
		if (r != null)
			for (bk in bh.keys())
				if (!ah.exists(bk)) rm.push(bk);
		
		Utils.saveHashes(c, ch);
		if (r != null) File.saveContent(r, rm.join('\n'));
	}

	private static function compareHash(a:Array<String>, b:Array<String>):Bool {
		if (a.length != b.length) return false;
		for (i in 0...a.length) {
			if (a[i] != b[i]) return false;
		}
		return true;
	}

	private function files(file:SPair<String>, list:Array<String>):Void {
		var map:Map<String, Array<String>> = Utils.getHashes(file.a);
		var nmap:Map<String, Array<String>> = new Map();
		var changesMap:Map<String, Array<String>> = new Map();
		Sys.println('Hashing');
		var startTime = Sys.time();
		ThreadTasksWhile.multyTask(threads, function(lock:Void->Void, unlock:Void->Void) {
			if (list.length > 0) {
				var e = list.pop();
				var stat = FileSystem.stat(e);
				unlock();
				var nt = Std.string(stat.mtime.getTime());
				var ns = Std.string(stat.size);
				
				if (map.exists(e)) {

					if (nt != map[e][0] || ns != map[e][1]) {
						var nd = [nt, ns];
						if (hash) {
							var nHash = Std.string(Crc32.make(File.getBytes(e)));
							nd.push(nHash);
							if (map[e][2] != nHash) {
								changesMap[e] = nd;
								Sys.print('!');
							} else {
								Sys.print('.');
							}
						} else {
							changesMap[e] = nd;
							Sys.print('!');
						}
						nmap[e] = nd;
					} else {
						nmap[e] = map[e];
						Sys.print('.');
					}

				} else {
					var nd = [nt, ns];
					if (hash)
						nd.push(Std.string(Crc32.make(File.getBytes(e))));
					changesMap[e] = nd;
					nmap[e] = nd;
					Sys.print('+');
				}

				return true;
			} else {
				Sys.print('^');
				return false;
			}
		});
		Utils.saveHashes(file.a, nmap);
		if (file.b != null) Utils.saveHashes(file.b, changesMap);
		Sys.println('');
		Sys.println('Hashing time: ' + Std.int((Sys.time() - startTime) * 1000) / 1000);
	}

	private function configHandler(cfg:HashConfig):Void {
		var filesPair = new SPair(cfg.stateFile, cfg.changesFile);
		var a = cfg.calc.a;
		var b = cfg.calc.b;
		var c = cfg.calc.c;
		var r = cfg.calc.r;
		if (cfg.before) {
			if (a != null || b != null || c != null || r != null) {
				if (!beforeCalc.exists(cfg.section))
					beforeCalc[cfg.section] = createCalcConfig();

				if (a != null) beforeCalc[cfg.section].a = a;
				if (b != null) beforeCalc[cfg.section].b = b;
				if (c != null) beforeCalc[cfg.section].c = c;
				if (r != null) beforeCalc[cfg.section].r = r;
			}

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
			if (a != null || b != null || c != null || r != null) {
				if (!afterCalc.exists(cfg.section))
					afterCalc[cfg.section] = createCalcConfig();

				if (a != null) afterCalc[cfg.section].a = a;
				if (b != null) afterCalc[cfg.section].b = b;
				if (c != null) afterCalc[cfg.section].c = c;
				if (r != null) afterCalc[cfg.section].r = r;
			}

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

	@:extern public static inline function createCalcConfig():CalcConfig return {a: null, b: null, c: null, r: null};

}

private typedef HashConfig = { > types.BAConfig,
	dirs: Array<String>,
	units: Array<String>,
	stateFile: String,
	changesFile: String,
	calc: CalcConfig
}

private class HashReader extends BAReader<HashConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'dir': cfg.dirs.push(StringTools.trim(xml.innerData));
			case 'unit': cfg.units.push(StringTools.trim(xml.innerData));
			case 'calc':
				allowEnd = false;
				new HashCalcReader(xml, copyCfg(), onConfig);
			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.dirs = [];
		cfg.units = [];
		cfg.calc = module.Hash.createCalcConfig();
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'state': cfg.stateFile = val;
			case 'changes': cfg.changesFile = val;
			case _:
		}
	}

}

private class HashCalcReader extends BAReader<HashConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'a': cfg.calc.a = StringTools.trim(xml.innerData);
			case 'b': cfg.calc.b = StringTools.trim(xml.innerData);
			case 'c': cfg.calc.c = StringTools.trim(xml.innerData);
			case 'r': cfg.calc.r = StringTools.trim(xml.innerData);
			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.dirs = [];
		cfg.units = [];
		cfg.calc = {a: null, b: null, c: null, r: null};
	}

}