package create.section;

import pony.Or;
import pony.text.XmlTools;
import pony.ds.KeyValue;

using pony.Tools;

typedef ConfigOptions = Map<String, Or<String, ConfigOptions>>;

/**
 * Config
 * @author AxGord <axgord@gmail.com>
 */
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