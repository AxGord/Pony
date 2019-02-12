package pony.text;

import pony.Fast;

typedef BaseConfig = {
	app: String,
	debug: Bool,
	?cordova: Bool
}

/**
 * XmlConfigReader
 * @author AxGord
 */
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
				case '_cordova':
					if (cfg.cordova) readXml(e);
					locAllowEnd = false;
				case '_notcordova':
					if (!cfg.cordova) readXml(e);
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