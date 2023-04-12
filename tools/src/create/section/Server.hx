package create.section;

import pony.text.XmlTools;

/**
 * Server
 * @author AxGord <axgord@gmail.com>
 */
class Server extends Section {

	public var httpPort: Int = 2000;
	public var httpPath: String = 'bin/';
	public var http: Bool = false;
	public var haxePort: Int = 6010;
	public var haxe: Bool = false;
	public var sniff: Bool = false;

	public function new() super('server');

	#if (haxe_ver < 4.2) override #end
	public function result(): Xml {
		init();
		if (http) {
			add('path', httpPath);
			add('port', Std.string(httpPort));
		}
		if (haxe) {
			add('haxe', Std.string(haxePort));
		}
		if (sniff) {
			var sniff: Xml = Xml.createElement('sniff');
			sniff.addChild(XmlTools.node('server', '3000'));
			sniff.addChild(XmlTools.node('client', '3001'));
			xml.addChild(sniff);
		}
		return xml;
	}

}