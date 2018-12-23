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
package create.section;

import pony.Or;
import pony.text.XmlTools;
import pony.KeyValue;

using pony.Tools;

typedef ConfigOptions = Map<String, Or<String, ConfigOptions>>;

class Config extends Section {

	public var options(default, null):ConfigOptions = new Map();
	public var dep:Array<String> = [];

	public function new() super('config');

	public function result():Xml {
		init();
		if (dep.length > 0) xml.set('dep', dep.join(', '));
		for (e in options.kv()) xml.addChild(make(e));
		return xml;
	}

	private function make(e:KeyValue<String, Or<String, ConfigOptions>>):Xml {
		var r = Xml.createElement(e.key);
		switch e.value {
			case OrState.A(v):
				r.addChild(XmlTools.data(v));
			case OrState.B(v):
				var allString:Bool = true;
				for (e in v.kv()) {
					switch e.value {
						case OrState.A(_):
						case OrState.B(_):
							allString = false;
					}
					r.addChild(make(e));
				}
				if (allString) r.set('type', 'stringmap');
		}
		return r;
	}

}