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
package pony.text;

import haxe.xml.Fast;

typedef BaseConfig = {
	app: String,
	debug: Bool
}

class XmlConfigReader<T:BaseConfig> {
	
	public var cfg:T;
	private var onConfig:T -> Void;
	private var allowEnd:Bool = true;

	public function new(xml:Fast, cfg:T, ?onConfig:T -> Void) {
		this.cfg = cfg;
		this.onConfig = onConfig;
		readXml(xml);
	}

	private function readAttr(name:String, val:String):Void {}
	private function readNode(xml:Fast):Void {}
	private function end():Void {}

	private function readXml(xml:Fast):Void {
		var locAllowEnd:Bool = true;
		for (a in xml.x.attributes()) readAttr(a, normalize(xml.x.get(a)));
		for (e in xml.elements) {
			switch e.name {
				case 'apps': 
					if (cfg.app != null) {
						if (e.hasNode.resolve(cfg.app))
							readXml(e.node.resolve(cfg.app));
					} else {
						for (node in e.elements)
							selfCreate(node);
					}
					locAllowEnd = false;
				case 'debug':
					if (cfg.debug) readXml(e);
					locAllowEnd = false;
				case 'release':
					if (!cfg.debug) readXml(e);
					locAllowEnd = false;
				case _: readNode(e);
			}
		}
		if (locAllowEnd && allowEnd) end();
	}

	private function normalize(s:String):String return StringTools.trim(s);

	private function copyCfg():T return pony.Tools.clone(cfg);

	private function _selfCreate<C:XmlConfigReader<T>>(xml:Fast, conf:T):C {
		allowEnd = false;
		return cast Type.createInstance(Type.getClass(this), [xml, conf, onConfig]);
	}

	private function selfCreate<C:XmlConfigReader<T>>(xml:Fast):C return _selfCreate(xml, copyCfg());

}