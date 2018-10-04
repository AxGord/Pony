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
import pony.fs.Unit;
import pony.fs.Dir;
import types.BASection;

/**
 * Url module
 * @author AxGord <axgord@gmail.com>
 */
class Url extends CfgModule<UrlConfig> {

	private static inline var PRIORITY:Int = 25;

	public function new() super('url');

	override public function init():Void initSections(PRIORITY, BASection.Build);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new UrlReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Build,
			url: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:UrlConfig):Void {
		for (u in cfg.url) url(u);
	}

	private function url(u:String):Void {
		log('Http request: $u');
		log(haxe.Http.requestUrl(u));
	}

}

private typedef UrlConfig = { > types.BAConfig,
	url: Array<String>
}

private class UrlReader extends BAReader<UrlConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'url': cfg.url.push(StringTools.trim(xml.innerData));
			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.url = [];
	}

}