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
 * Module
 * @author AxGord <axgord@gmail.com>
 */
class Module extends pony.Logable implements pony.magic.HasAbstract {

	private static inline var CONFIG_PRIORITY:Int = -20;

	public var modules:Modules;
	private var xml(get, never):Fast;
	private var _xml:Fast;
	private var xname:String;

	public function new(?xname:String) {
		super();
		this.xname = xname;
	}

	private function get_xml():Fast {
		if (_xml == null)
			_xml = xname == null ? modules.xml : modules.getNode(xname);
		return _xml;
	}

	@:abstract public function init():Void;
	private function readConfig(ac:AppCfg):Void {}

	private function addConfigListener():Void {
		modules.commands.onServer.once(emptyConfig, CONFIG_PRIORITY);
		modules.commands.onPrepare.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onBuild.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onRun.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onZip.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onHash.once(emptyConfig, CONFIG_PRIORITY);
	}

	private function removeConfigListener():Void {
		modules.commands.onServer >> emptyConfig;
		modules.commands.onPrepare >> getConfig;
		modules.commands.onBuild >> getConfig;
		modules.commands.onRun >> getConfig;
		modules.commands.onZip >> getConfig;
		modules.commands.onHash >> emptyConfig;
	}

	private function addListeners(priority:Int, before:BASection -> Void, after:BASection -> Void):Void {
		modules.commands.onServer.once(before.bind(Server), -priority);
		modules.commands.onPrepare.once(before.bind(Prepare), -priority);
		modules.commands.onBuild.once(before.bind(Build), -priority);
		modules.commands.onRun.once(before.bind(Run), -priority);
		modules.commands.onZip.once(before.bind(Zip), -priority);
		modules.commands.onHash.once(before.bind(Hash), -priority);

		modules.commands.onServer.once(after.bind(Server), priority);
		modules.commands.onPrepare.once(after.bind(Prepare), priority);
		modules.commands.onBuild.once(after.bind(Build), priority);
		modules.commands.onRun.once(after.bind(Run), priority);
		modules.commands.onZip.once(after.bind(Zip), priority);
		modules.commands.onHash.once(after.bind(Hash), priority);
	}

	private function getConfig(a:String, b:String):Void {
		removeConfigListener();
		readConfig(Utils.parseArgs([a, b]));
	}

	private function emptyConfig():Void {
		removeConfigListener();
		readConfig({debug:false, app:null});
	}

}