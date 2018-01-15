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

using pony.text.XmlTools;

/**
 * Unpack module
 * @author AxGord <axgord@gmail.com>
 */
class Unpack extends Module {

	private static inline var PRIORITY:Int = 5;

	private var beforeZips:Map<BASection, Array<ZipConfig>> = new Map();
	private var afterZips:Map<BASection, Array<ZipConfig>> = new Map();

	public function new() super('unpack');

	override public function init():Void {
		if (xml == null) return;
		addConfigListener();
		addListeners(PRIORITY, before, after);
	}

	override private function readConfig(ac:AppCfg):Void {
		new UnpackReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			zips: []
		}, configHandler);
	}

	private function configHandler(cfg:UnpackConfig):Void {
		if (cfg.zips.length == 0) return;
		if (cfg.before) {
			if (beforeZips.exists(cfg.section))
				beforeZips[cfg.section] = beforeZips[cfg.section].concat(cfg.zips);
			else
				beforeZips[cfg.section] = cfg.zips;
		} else {
			if (afterZips.exists(cfg.section))
				afterZips[cfg.section] = afterZips[cfg.section].concat(cfg.zips);
			else
				afterZips[cfg.section] = cfg.zips;
		}
	}

	private function before(section:BASection):Void {
		if (!beforeZips.exists(section)) return;
		for (c in beforeZips[section]) unzip(c);
	}

	private function after(section:BASection):Void {
		if (!afterZips.exists(section)) return;
		for (c in afterZips[section]) unzip(c);
	}

	private function unzip(c:ZipConfig):Void {
		log('Unzip: ' + c.file);
		pony.ZipTool.unpackFile(c.file, c.path, c.log ? function(s:String) log(s) : null);
		if (c.rm) {
			log('Delete: ' + c.file);
			sys.FileSystem.deleteFile(c.file);
		}

	}
	
}

private typedef ZipConfig = {
	path: String,
	file: String,
	rm: Bool,
	log: Bool
}

private typedef UnpackConfig = { > types.BAConfig,
	zips: Array<ZipConfig>
}

private class UnpackReader extends BAReader<UnpackConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'zip': 
				cfg.zips.push({
					path: try StringTools.trim(xml.innerData) catch (_:Any) '',
					file: xml.att.file,
					rm: xml.isTrue('rm'),
					log: !xml.isFalse('log')
				});

			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.zips = [];
	}

}
