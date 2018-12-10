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
import types.PoeditorConfig;
import pony.text.TextTools;

class Poeditor extends NModule<PoeditorConfig> {

	private static inline var PRIORITY:Int = 32;

	public function new() super('poeditor');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new PoeditorReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			path: '',
			id: null,
			token: null,
			list: null,
			allowCfg: true
		}, configHandler);
	}

	override private function writeCfg(protocol:NProtocol, cfg:Array<PoeditorConfig>):Void {
		for (c in cfg) sys.FileSystem.createDirectory(c.path);
		protocol.poeditorRemote(cfg);
	}

}

private class PoeditorReader extends BAReader<PoeditorConfig> {

	override private function clean():Void {
		cfg.path = '';
		cfg.id = null;
		cfg.token = null;
		cfg.list = null;
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'path': cfg.path = StringTools.trim(xml.innerData);
			case 'id': cfg.id = Std.parseInt(xml.innerData);
			case 'token': cfg.token = StringTools.trim(xml.innerData);
			case 'list': cfg.list = [for (x in xml.elements) StringTools.trim(x.innerData) => x.name];

			case _: super.readNode(xml);
		}
	}

}