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

	private var beforeDirs:Map<BASection, Array<String>> = new Map();
	private var beforeUnits:Map<BASection, Array<String>> = new Map();
	private var afterDirs:Map<BASection, Array<String>> = new Map();
	private var afterUnits:Map<BASection, Array<String>> = new Map();

	public function new() super('clean');

	override public function init():Void {
		if (xml == null) return;

		modules.commands.onServer.once(emptyConfig, -20);
		modules.commands.onPrepare.once(getConfig, -20);
		modules.commands.onBuild.once(getConfig, -20);
		modules.commands.onRun.once(getConfig, -20);
		modules.commands.onZip.once(getConfig, -20);

		modules.commands.onServer.once(before.bind(Server), -10);
		modules.commands.onPrepare.once(before.bind(Prepare), -10);
		modules.commands.onBuild.once(before.bind(Build), -10);
		modules.commands.onRun.once(before.bind(Run), -10);
		modules.commands.onZip.once(before.bind(Zip), -10);

		modules.commands.onServer.once(after.bind(Server), 10);
		modules.commands.onPrepare.once(after.bind(Prepare), 10);
		modules.commands.onBuild.once(after.bind(Build), 10);
		modules.commands.onRun.once(after.bind(Run), 10);
		modules.commands.onZip.once(after.bind(Zip), 10);
	}

	private function readConfig(ac:AppCfg):Void {

		modules.commands.onServer >> emptyConfig;
		modules.commands.onPrepare >> getConfig;
		modules.commands.onBuild >> getConfig;
		modules.commands.onRun >> getConfig;
		modules.commands.onZip >> getConfig;

		new CleanReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			units: []
		}, configHandler);
	}

	private function getConfig(a:String, b:String):Void readConfig(Utils.parseArgs([a, b]));

	private function emptyConfig():Void readConfig({debug:false, app:null}); 

	private function before(section:BASection):Void {
		if (beforeDirs.exists(section)) {
			for (d in beforeDirs[section]) {
				log('Clean directory: $d');
				(d:Dir).deleteContent();
			}
		}
		if (beforeUnits.exists(section)) {
			for (u in beforeUnits[section]) {
				log('Delete file: $u');
				(u:Unit).delete();
			}
		}
	}

	private function after(section:BASection):Void {
		if (afterDirs.exists(section)) {
			for (d in afterDirs[section]) {
				log('Clean directory: $d');
				(d:Dir).deleteContent();
			}
		}
		if (afterUnits.exists(section)) {
			for (u in afterUnits[section]) {
				log('Delete file: $u');
				(u:Unit).delete();
			}
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