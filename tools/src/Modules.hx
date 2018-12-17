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

import haxe.xml.Fast;
import pony.text.XmlTools;
import module.Build;
import module.Module;

/**
 * Modules
 * @author AxGord <axgord@gmail.com>
 */
class Modules extends pony.Logable {

	public var xml(get, null):Fast;
	private var _xml:Fast;
	public var commands(default, null):Commands;
	public var list:Array<Module> = [];
	public var build:Build;

	public function new(commands:Commands) {
		super();
		this.commands = commands;
		onError << commands.error;
		onLog << commands.log;
	}

	private function get_xml():Fast {
		if (_xml == null)
			_xml = Utils.getXml();
		return _xml;
	}

	public function register<T:Module>(module:T):Void {
		module.modules = this;
		module.onError << error;
		module.onLog << log;
		list.push(module);
		switch Type.getClass(module) {
			case Build:
				build = cast module;
			case _:
		}
	}

	public function init():Void {
		for (m in list) m.init();
	}

	@:extern public inline function getNode(name:String):Fast {
		return XmlTools.getNode(xml, name);
	}

}