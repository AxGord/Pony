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
import sys.io.File;
import types.BASection;

/**
 * Uglify module
 * @author AxGord <axgord@gmail.com>
 */
class Wrapper extends CfgModule<WrapperConfig> {

	private static inline var PRIORITY:Int = 4;

	public function new() super('wrapper');

	override public function init():Void initSections(PRIORITY);

	override private function readConfig(ac:AppCfg):Void {
		new WrapperReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Build,
			file: null,
			pre: '',
			post: ''
		}, configHandler);
	}

	override private function run(cfg:WrapperConfig):Void {
		var file = cfg.file;
		var pre = cfg.pre;
		var post = cfg.post;
		if (cfg.file != null && (pre != '' || post != '')) {
			Sys.println('Apply wrapper to ' + file);
			var data = File.getContent(file);
			if (pre != null) data = pre + data;
			if (post != null) data = data + post;
			File.saveContent(file, data);
		}
	}

}

private typedef WrapperConfig = { > types.BAConfig,
	pre: String,
	post: String,
	file: String
}

private class WrapperReader extends BAReader<WrapperConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'file':
				cfg.file = StringTools.trim(xml.innerData);
			case 'pre':
				cfg.pre = StringTools.trim(xml.innerData);
			case 'post':
				cfg.post = StringTools.trim(xml.innerData);
			case _:
				super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.file = null;
		cfg.pre = '';
		cfg.post = '';
	}

}