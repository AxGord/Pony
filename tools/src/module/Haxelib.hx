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

import pony.Pair;
import haxe.xml.Fast;
import types.BAConfig;
import types.BASection;
import pony.text.TextTools;

typedef HaxelibConfig = { > BAConfig,
	list: Array<String>
}

/**
 * Haxelib
 * @author AxGord <axgord@gmail.com>
 */
class Haxelib extends CfgModule<HaxelibConfig> {

	private static inline var PRIORITY:Int = 1;

	public function new() super('haxelib');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new HaxelibReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			list: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:HaxelibConfig):Void {
		for (lib in cfg.list) {
			var args:Array<String> = ['install'];
			args = args.concat(lib.split(' '));
			args.push('--always');
			Sys.command('haxelib', args);
		}
	}

}

private class HaxelibReader extends BAReader<HaxelibConfig> {

	override private function clean():Void {
		cfg.list = [];
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'lib': cfg.list.push(StringTools.trim(xml.innerData));
			case _: super.readNode(xml);
		}
	}

}