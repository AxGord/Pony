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
import types.BAConfig;
import types.BASection;

/**
 * CfgModule
 * @author AxGord <axgord@gmail.com>
 */
class CfgModule<T:BAConfig> extends Module implements pony.magic.HasAbstract {

	private var lastcfgs:Array<T> = [];
	private var allcfgs:Array<Array<T>> = [];

	override public function init():Void throw 'Abstract';

	private function configHandler(cfg:T):Void lastcfgs.push(cfg);

	private function savecfg():Void {
		if (lastcfgs.length > 0) {
			allcfgs.push(lastcfgs);
			lastcfgs = [];
		}
	}

	override private function readConfig(ac:AppCfg):Void {
		for (xml in nodes) {
			readNodeConfig(xml, ac);
			savecfg();
		}
	}

	override private function runModule(before:Bool, section:BASection):Void {
		for (cfgs in allcfgs) {
			var actual:Array<T> = [];
			for (cfg in cfgs)
				if (cfg.before == before && cfg.section == section)
					actual.push(cfg);
			if (actual.length > 0) {
				begin();
				run(actual);
				end();
			}
		}
	}

	private function run(cfg:Array<T>):Void for (e in cfg) runNode(e);
	private function readNodeConfig(xml:Fast, ac:AppCfg):Void {}
	private function runNode(cfg:T):Void {}

}