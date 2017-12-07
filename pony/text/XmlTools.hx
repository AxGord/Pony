/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

class XmlTools {

	public static inline var XML_REMSP_LEFT:String = '{REMSP_LEFT}';
	public static inline var XML_REMSP_RIGHT:String = '{REMSP_RIGHT}';

	inline public static function isTrue(x:haxe.xml.Fast, name:String):Bool return x.has.resolve(name) && TextTools.isTrue(x.att.resolve(name));
	inline public static function fast(text:String):Fast return new haxe.xml.Fast(Xml.parse(text));

	public static function document(xml:Xml):String {
		var doc = Xml.createDocument();
		doc.addChild(Xml.createProcessingInstruction('xml version="1.0" encoding="utf-8"'));
		doc.addChild(xml);
		var r = haxe.xml.Printer.print(doc, true);
		
		var a = r.split(XML_REMSP_LEFT);
		r = '';
		for (e in a) r += e.substring(0, e.lastIndexOf('>') + 1);
		a = r.split(XML_REMSP_RIGHT);
		r = '';
		for (e in a) r += e.substring(e.indexOf('<'));

		return r;
	}

	public static function data(data:String):Xml {
		return Xml.createPCData(XML_REMSP_LEFT + data + XML_REMSP_RIGHT);
	}

	public static function node(v:String, t:String):Xml {
		var e = Xml.createElement(v);
		e.addChild(data(t));
		return e;
	}

	public static function att(v:String, att:String, data:String):Xml {
		var e = Xml.createElement(v);
		e.set(att, data);
		return e;
	}

	public static function mapToNode(name:String, tag:String, map:Map<String, String>):Xml {
		var r = Xml.createElement(name);
		for (key in map.keys())
			r.addChild(att(tag, key, map[key]));
		return r;
	}

	public static function getNode(xml:Fast, name:String):Fast {
		return xml != null && xml.hasNode.resolve(name) ? xml.node.resolve(name) : null;
	}

}