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
import pony.fs.Unit;
import pony.fs.Dir;
import types.BASection;

/**
 * Clean module
 * @author AxGord <axgord@gmail.com>
 */
class Clean extends Module {

	private static inline var PRIORITY:Int = 10;

	private var beforeDirs:Map<BASection, Array<String>> = new Map();
	private var beforeUnits:Map<BASection, Array<String>> = new Map();
	private var afterDirs:Map<BASection, Array<String>> = new Map();
	private var afterUnits:Map<BASection, Array<String>> = new Map();

	public function new() super('clean');

	override public function init():Void {
		if (xml == null) return;
		addConfigListener();
		addListeners(PRIORITY, before, after);
	}

	override private function readConfig(ac:AppCfg):Void {
		new CleanReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			units: []
		}, configHandler);
	}

	private function before(section:BASection):Void {
		if (beforeDirs.exists(section)) cleanDirs(beforeDirs[section]);
		if (beforeUnits.exists(section)) deleteUnits(beforeUnits[section]);
	}

	private function after(section:BASection):Void {
		if (afterDirs.exists(section)) cleanDirs(afterDirs[section]);
		if (afterUnits.exists(section)) deleteUnits(afterUnits[section]);
	}

	private function cleanDirs(data:Array<String>):Void {
		for (d in data) {
			log('Clean directory: $d');
			(d:Dir).deleteContent();
		}
	}

	private function deleteUnits(data:Array<String>):Void {
		for (u in data) {
			log('Delete file: $u');
			(u:Unit).delete();
		}
	}

	private function configHandler(cfg:CleanConfig):Void {
		if (cfg.before) {
			if (cfg.dirs.length > 0) {
				if (beforeDirs.exists(cfg.section)) {
					beforeDirs[cfg.section] = beforeDirs[cfg.section].concat(cfg.dirs);
				} else {
					beforeDirs[cfg.section] = cfg.dirs;
				}
			}
			if (cfg.units.length > 0) {
				if (beforeUnits.exists(cfg.section)) {
					beforeUnits[cfg.section] = beforeUnits[cfg.section].concat(cfg.units);
				} else {
					beforeUnits[cfg.section] = cfg.units;
				}
			}
		} else {
			if (cfg.dirs.length > 0) {
				if (afterDirs.exists(cfg.section)) {
					afterDirs[cfg.section] = afterDirs[cfg.section].concat(cfg.dirs);
				} else {
					afterDirs[cfg.section] = cfg.dirs;
				}
			}
			if (cfg.units.length > 0) {
				if (afterUnits.exists(cfg.section)) {
					afterUnits[cfg.section] = afterUnits[cfg.section].concat(cfg.units);
				} else {
					afterUnits[cfg.section] = cfg.units;
				}
			}
		}
	}

}

private typedef CleanConfig = { > types.BAConfig,
	dirs: Array<String>,
	units: Array<String>
}

private class CleanReader extends BAReader<CleanConfig> {

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

}