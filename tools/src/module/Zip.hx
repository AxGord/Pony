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
 * Zip
 * @author AxGord <axgord@gmail.com>
 */
class Zip extends CfgModule<ZipConfig> {

	private static inline var PRIORITY:Int = 12;

	public function new() super('zip');

	override public function init():Void initSections(PRIORITY, BASection.Zip);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new ZipConfigReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Zip,
			input: [],
			output: 'app.zip',
			prefix: 'bin/',
			compressLvl: 9,
			log: true,
			hash: null,
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:ZipConfig):Void {
		log('Archive name: ${cfg.output}');
		var zip = new pony.ZipTool(Utils.replaceBuildDate(cfg.output), cfg.prefix, cfg.compressLvl);
		if (cfg.log) zip.onLog << log;
		zip.onError << function(err:String) throw err;
		if (cfg.hash != null)
			zip.writeHash(Utils.getHashes(cfg.hash));
		zip.writeList(cfg.input).end();
	}

}

private typedef ZipConfig = { > types.BAConfig,
	input: Array<String>,
	output: String,
	prefix: String,
	compressLvl: Int,
	hash: String,
	log: Bool
}

private class ZipConfigReader extends BAReader<ZipConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'input': cfg.input.push(StringTools.trim(xml.innerData));
			case 'output': cfg.output = StringTools.trim(xml.innerData);
			case 'prefix': cfg.prefix = StringTools.trim(xml.innerData);
			case 'compress': cfg.compressLvl = Std.parseInt(xml.innerData);
			case 'hash': cfg.hash = StringTools.trim(xml.innerData);

			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.input = [];
		cfg.output = 'app.zip';
		cfg.prefix = 'bin/';
		cfg.compressLvl = 9;
		cfg.hash = null;
		cfg.log = true;
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'log': cfg.log = !pony.text.TextTools.isFalse(val);
			case _:
		}
	}

}