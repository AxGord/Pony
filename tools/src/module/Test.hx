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
import types.BASection;

/**
 * Uglify module
 * @author AxGord <axgord@gmail.com>
 */
class Test extends CfgModule<TestConfig> {

	private static inline var PRIORITY:Int = 5;

	public function new() super('test');

	override public function init():Void initSections(PRIORITY);

	override private function readConfig(ac:AppCfg):Void {
		new TestReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Build,
			path: null,
			test: []
		}, configHandler);
	}

	override private function run(cfg:TestConfig):Void {
		var cwd:Cwd = cfg.path;
		cwd.sw();
		for (t in cfg.test) {
			var args = t.split(' ');
			var cmd = args.shift();
			Utils.command(cmd, args);
		}
		cwd.sw();
	}

}

private typedef TestConfig = { > types.BAConfig,
	path: String,
	test: Array<String>
}

private class TestReader extends BAReader<TestConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'test':
				cfg.test.push(StringTools.trim(xml.innerData));
			case _:
				super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.path = null;
		cfg.test = [];
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'test': cfg.path = val;
			case _:
		}
	}

}