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
import types.BmfontConfig;

class Bmfont extends NModule<BmfontConfig> {

	private static inline var PRIORITY:Int = 20;

	public function new() super('bmfont');

	override public function init():Void {
		if (xml == null) return;
		initSections(PRIORITY, BASection.Prepare);
	}

	override private function readConfig(ac:AppCfg):Void {
		for (xml in nodes)
			new BmfontReader(xml, {
				debug: ac.debug,
				app: ac.app,
				before: false,
				section: BASection.Prepare,
				from: '',
				to: '',
				font: []
			}, configHandler);
	}

	override private function writeCfg(cfg:BmfontConfig):Void {
		protocol.bmfont = cfg;
	}

}

private class BmfontReader extends BAReader<BmfontConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'font': cfg.font.push({file: StringTools.trim(xml.innerData), size: Std.parseInt(xml.att.size)});
			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.from = '';
		cfg.to = '';
		cfg.font = [];
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'from': cfg.from = val;
			case 'to': cfg.to = val;
			case _:
		}
	}

}
