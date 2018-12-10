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
import types.BAConfig;

typedef RunConfig = { > BAConfig,
	path: String,
	cmd: String
}

class Run extends CfgModule<RunConfig> {

	private static inline var PRIORITY:Int = 0;

	public function new() super('run');

	override public function init():Void initSections(PRIORITY, BASection.Run);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new RunReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Run,
			path: null,
			cmd: null,
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:RunConfig):Void {
		var cwd = new Cwd(cfg.path);
		cwd.sw();

		var args = cfg.cmd.split(' ');
		var cmd = args.shift();
		Utils.command(cmd, args);

		cwd.sw();
	}

}

private class RunReader extends BAReader<RunConfig> {

	override private function clean():Void {
		cfg.path = null;
		cfg.cmd = null;
	}

	override private function readXml(xml:Fast):Void {
		for (a in xml.x.attributes()) readAttr(a, normalize(xml.x.get(a)));
		cfg.cmd = normalize(xml.innerData);
		if (allowEnd) end();
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'path': cfg.path = val;
			case _:
		}
	}

}