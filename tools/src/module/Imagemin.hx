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
import types.ImageminConfig;
import pony.text.TextTools;

class Imagemin extends NModule<ImageminConfig> {

	private static inline var PRIORITY:Int = 22;

	public function new() super('imagemin');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new ImageminReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			from: '',
			to: '',
			jpgq: 85,
			webpq: 50,
			webpfrompng: false,
			jpgfrompng: false,
			allowCfg: false
		}, configHandler);
	}

	override private function writeCfg(protocol:NProtocol, cfg:Array<ImageminConfig>):Void protocol.imageminRemote(cfg);

}

private class ImageminReader extends BAReader<ImageminConfig> {

	override private function clean():Void {
		cfg.from = '';
		cfg.to = '';
		cfg.format = null;
		cfg.pngq = null;
		cfg.jpgq = 85;
		cfg.webpq = 50;
		cfg.webpfrompng = false;
		cfg.jpgfrompng = false;
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'from': cfg.from += val;
			case 'to': cfg.to += val;
			case 'format': cfg.format = val;
			case 'pngq': cfg.pngq = Std.parseInt(val);
			case 'jpgq': cfg.jpgq = Std.parseInt(val);
			case 'webpq': cfg.webpq = Std.parseInt(val);
			case 'webpfrompng': cfg.webpfrompng = TextTools.isTrue(val);
			case 'jpgfrompng': cfg.jpgfrompng = TextTools.isTrue(val);
			case _:
		}
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'dir': allowCreate(xml);
			case 'path': denyCreate(xml);

			case _: super.readNode(xml);
		}
	}

}
