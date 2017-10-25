package pony.text;

import haxe.xml.Fast;

typedef BaseConfig = {
	app: String,
	debug: Bool
}

class XmlConfigReader<T:BaseConfig> {
	
	public var cfg:T;
	private var onConfig:T->Void;

	public function new(xml:Fast, cfg:T, ?onConfig:T->Void) {
		this.cfg = cfg;
		this.onConfig = onConfig;
		for (a in xml.x.attributes()) readAttr(a, normalize(xml.x.get(a)));
		readXml(xml);
	}

	private function readAttr(name:String, val:String):Void {}
	private function readNode(xml:Fast):Void {}
	private function end():Void {}

	private function readXml(xml:Fast):Void {
		for (e in xml.elements) {
			switch e.name {
				case 'apps': 
					if (cfg.app != null) {
						readXml(e.node.resolve(cfg.app));
					} else {
						for (node in e.elements) selfCreate(node);
					}
				case 'debug': if (cfg.debug) readXml(e);
				case 'release': if (!cfg.debug) readXml(e);
				case _: readNode(e);
			}
		}
		end();
	}

	private function normalize(s:String):String return StringTools.trim(s);

	private function copyCfg():T return pony.Tools.clone(cfg);

	private function selfCreate<C:XmlConfigReader<T>>(xml:Fast):C return cast Type.createInstance(Type.getClass(this), [xml, copyCfg(), onConfig]);

}