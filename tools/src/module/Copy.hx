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
class Copy extends CfgModule<CopyConfig> {

	private static inline var PRIORITY:Int = 21;

	public function new() super('copy');
	
	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new CopyReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			units: [],
			to: '',
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:CopyConfig):Void {
		copyDirs(cfg.dirs, cfg.to, cfg.filter);
		copyUnits(cfg.units, cfg.to);
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
			var unit:Unit = u;
			if (unit.isFile)
				(unit:File).copyToDir(to);
			else
				error('Is not file!');
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