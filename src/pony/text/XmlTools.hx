package pony.text;

import pony.Fast;

/**
 * XmlTools
 * @author AxGord <axgord@gmail.com>
 */
class XmlTools {

	public static inline var XML_REMSP_LEFT: String = '{REMSP_LEFT}';
	public static inline var XML_REMSP_RIGHT: String = '{REMSP_RIGHT}';

	public static inline function isTrue(x: Fast, name: String): Bool return x.has.resolve(name) && TextTools.isTrue(x.att.resolve(name));
	public static inline function isFalse(x: Fast, name: String): Bool return x.has.resolve(name) && TextTools.isFalse(x.att.resolve(name));
	public static inline function fast(text: String): Fast return new Fast(Xml.parse(text));

	public static function document(xml: Xml): String {
		var doc: Xml = Xml.createDocument();
		doc.addChild(Xml.createProcessingInstruction('xml version="1.0" encoding="utf-8"'));
		doc.addChild(xml);
		var r: String = haxe.xml.Printer.print(doc, true);

		var a: Array<String> = r.split(XML_REMSP_LEFT);
		r = '';
		for (e in a) r += e.substring(0, e.lastIndexOf('>') + 1);
		a = r.split(XML_REMSP_RIGHT);
		r = '';
		for (e in a) r += e.substring(e.indexOf('<'));

		return r;
	}

	public static function data(data: String): Xml {
		return Xml.createPCData(XML_REMSP_LEFT + data + XML_REMSP_RIGHT);
	}

	public static function node(v: String, t: String): Xml {
		var e: Xml = Xml.createElement(v);
		e.addChild(data(t));
		return e;
	}

	public static function att(v: String, att: String, data: String): Xml {
		var e: Xml = Xml.createElement(v);
		e.set(att, data);
		return e;
	}

	public static function mapToNode(name: String, tag: String, map: Map<String, String>): Xml {
		var r: Xml = Xml.createElement(name);
		for (key in map.keys())
			r.addChild(att(tag, key, map[key]));
		return r;
	}

	public static function getNode(xml: Fast, name: String): Fast {
		return xml != null && xml.hasNode.resolve(name) ? xml.node.resolve(name) : null;
	}

	public static function intagReplace(text: String, tag: String, value: String): String {
		return TextTools.betweenReplace(text, '<$tag>', '</$tag>', value);
	}

}