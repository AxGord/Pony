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
import types.BASection;
import types.DownloadConfig;
import pony.text.TextTools;

/**
 * Donwload
 * @author AxGord <axgord@gmail.com>
 */
class Download extends NModule<DownloadConfig> {

	private static inline var PRIORITY:Int = 30;

	public function new() super('download');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new DownloadReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			path: '',
			units: [],
			allowCfg: true
		}, configHandler);
	}

	override private function writeCfg(protocol:NProtocol, cfg:Array<DownloadConfig>):Void {
		for (c in cfg) sys.FileSystem.createDirectory(c.path);
		protocol.downloadRemote(cfg);
	}

}

private class DownloadReader extends BAReader<DownloadConfig> {

	override private function clean():Void {
		cfg.path = '';
		cfg.units = [];
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'path': cfg.path += val;
			case _:
		}
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'unit':
				var p:Pair<String, String> = if (xml.has.v) {
					var v = xml.att.v;
					new Pair(StringTools.replace(xml.att.url, '{v}', v), xml.has.check ? StringTools.replace(xml.att.check, '{v}', v) : null);
				} else {
					new Pair(xml.att.url, xml.has.check ? xml.att.check : null);
				}
				cfg.units.push(p);

			case _: super.readNode(xml);
		}
	}

}