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
import pony.fs.File;
import types.BASection;

/**
 * Copy module
 * @author AxGord <axgord@gmail.com>
 */
class Copy extends Module {

	private static inline var PRIORITY:Int = 25;

	private var beforeDirs:Map<BASection, Array<String>> = new Map();
	private var beforeUnits:Map<BASection, Array<String>> = new Map();
	private var afterDirs:Map<BASection, Array<String>> = new Map();
	private var afterUnits:Map<BASection, Array<String>> = new Map();
	private var beforeFilter:Map<BASection, String> = new Map();
	private var afterFilter:Map<BASection, String> = new Map();
	private var beforeTo:Map<BASection, String> = new Map();
	private var afterTo:Map<BASection, String> = new Map();

	public function new() super('copy');
	
	override public function init():Void {
		if (xml == null) return;
		addConfigListener();
		addListeners(PRIORITY, before, after);
	}

	override private function readConfig(ac:AppCfg):Void {
		new CopyReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			units: [],
			to: ''
		}, configHandler);
	}

	private function before(section:BASection):Void {
		if (beforeDirs.exists(section)) copyDirs(beforeDirs[section], beforeTo[section], beforeFilter[section]);
		if (beforeUnits.exists(section)) copyUnits(beforeUnits[section], beforeTo[section]);
	}

	private function after(section:BASection):Void {
		if (afterDirs.exists(section)) copyDirs(afterDirs[section], afterTo[section], afterFilter[section]);
		if (afterUnits.exists(section)) copyUnits(afterUnits[section], afterTo[section]);
	}

	private function copyDirs(data:Array<String>, to:String, filter:String):Void {
		for (d in data) {
			log('Copy directory: $d');
			(d:Dir).copyTo(to, filter);
		}
	}

	private function copyUnits(data:Array<String>, to:String):Void {
		for (u in data) {
			log('Copy file: $u');
			var unit:Unit = cast u;
			if (unit.isFile)
				(unit:File).copyTo(to);
			else
				error('Is not file!');
		}
	}

	private function configHandler(cfg:CopyConfig):Void {
		if (cfg.before) {
			if (cfg.dirs.length > 0) {
				if (beforeDirs.exists(cfg.section)) {
					beforeDirs[cfg.section] = beforeDirs[cfg.section].concat(cfg.dirs);
				} else {
					beforeDirs[cfg.section] = cfg.dirs;
				}
				beforeFilter[cfg.section] = cfg.filter;
				beforeTo[cfg.section] = cfg.to;
			}
			if (cfg.units.length > 0) {
				if (beforeUnits.exists(cfg.section)) {
					beforeUnits[cfg.section] = beforeUnits[cfg.section].concat(cfg.units);
				} else {
					beforeUnits[cfg.section] = cfg.units;
				}
				beforeTo[cfg.section] = cfg.to;
			}
		} else {
			if (cfg.dirs.length > 0) {
				if (afterDirs.exists(cfg.section)) {
					afterDirs[cfg.section] = afterDirs[cfg.section].concat(cfg.dirs);
				} else {
					afterDirs[cfg.section] = cfg.dirs;
				}
				afterFilter[cfg.section] = cfg.filter;
				afterTo[cfg.section] = cfg.to;
			}
			if (cfg.units.length > 0) {
				if (afterUnits.exists(cfg.section)) {
					afterUnits[cfg.section] = afterUnits[cfg.section].concat(cfg.units);
				} else {
					afterUnits[cfg.section] = cfg.units;
				}
				afterTo[cfg.section] = cfg.to;
			}
		}
	}

}

private typedef CopyConfig = { > types.BAConfig,
	dirs: Array<String>,
	units: Array<String>,
	?filter: String,
	to: String
}

private class CopyReader extends BAReader<CopyConfig> {

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
		cfg.filter = null;
		cfg.to = '';
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'filter': cfg.filter = val;
			case 'to': cfg.to = val;
			case _:
		}
	}


}