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
class Clean extends CfgModule<CleanConfig> {

	private static inline var PRIORITY:Int = 10;

	public function new() super('clean');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readConfig(ac:AppCfg):Void {
		for (xml in nodes) {
			new CleanReader(xml, {
				debug: ac.debug,
				app: ac.app,
				before: false,
				section: Prepare,
				dirs: [],
				units: []
			}, configHandler);
		}
	}

	override private function run(cfg:CleanConfig):Void {
		cleanDirs(cfg.dirs);
		deleteUnits(cfg.units);
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