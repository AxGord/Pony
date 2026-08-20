package create.section;

import pony.Or;
import pony.ds.KeyValue;
import pony.text.XmlTools;

using pony.Tools;

typedef ConfigOptions = Map<String, Or<String, ConfigOptions>>;

/**
 * Config
 * @author AxGord <axgord@gmail.com>
 */
class Config extends Section {

	public var options(default, null): ConfigOptions = [];
	public var dep: Array<String> = [];
	public var stringmapAllowed: Bool = true;

	public function new() super('config');

	#if (haxe_ver < 4.2) override #end
	public function result(): Xml {
		init();
		if (dep.length > 0) xml.set('dep', dep.join(', '));
		for (e in options.kv()) xml.addChild(make(e));
		return xml;
	}

	private function make(e: KeyValue<String, Or<String, ConfigOptions>>): Xml {
		final r: Xml = Xml.createElement(e.key);
		switch e.value {
			case OrState.A(v):
				r.addChild(XmlTools.data(v));
			case OrState.B(v):
				var allString: Bool = stringmapAllowed;
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
