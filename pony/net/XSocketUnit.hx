package pony.net;

import haxe.xml.Fast;
import pony.XMLTools;


/**
 * ...
 * @author AxGord
 */

class XSocketUnit extends SocketUnit
{
	private var getwaits:Hash<Array<Dynamic->Void>> = new Hash<Array<Dynamic->Void>>();
	
	public function get(name:String, f:Dynamic->Void):Void {
		if (getwaits.exists(name)) {
			getwaits.get(name).push(f);
		} else {
			var x:Xml = Xml.createElement('get');
			x.set('name', name);
			getwaits.set(name, [f]);
			send(x.toString());
		}
	}
	
	override private function onData(d:String):Void 
	{
		var x:Xml;
		try {
			x = Xml.parse(d);
		} catch (e:Dynamic) {
			super.onData(d);
			return;
		}
		for (e in x)
			if (e.nodeType+'' == 'element') {
				switch (e.nodeName) {
					case 'get':
						untyped parent.xGet(e.get('name'), respF(e.get('name')));
					case 'response':
						switch (e.get('request')) {
							case 'get':
								getResponse(e.get('name'), e.firstChild());
						}
				}
			} else super.onData(e.toString());
	}
	
	private function respF(n:String):Dynamic return function(v:Xml) responseGet(n, v)
	
	private function responseGet(n:String, v:Xml):Void {
		var x:Xml = Xml.createElement('response');
		x.set('request', 'get');
		x.set('name', n);
		x.addChild(v);
		send(x.toString());
	}
	
	private function getResponse(n:String, x:Xml):Void {
		if (getwaits.exists(n)) {
			var v:Dynamic = XMLTools.unserialize(x);
			for (f in getwaits.get(n)) f(v);
			getwaits.remove(n);
		}
	}
	
}