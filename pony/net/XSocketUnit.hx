package pony.net;

import haxe.Serializer;
import haxe.Unserializer;
import haxe.xml.Fast;
import pony.SpeedLimit;

/**
 * @author AxGord
 */

class XSocketUnit extends SocketUnit
{
	private var xw:SpeedLimit = new SpeedLimit(5000);
	
	private var getwaits:Hash < Array < Dynamic->Void >> = new Hash < Array < Dynamic->Void >> ();
	private var callwaits:Array < {n:String, f:Dynamic->Void} > = [];
	
	private var xParent(getXparent, null):XSocket<Dynamic>;
	
	private function getXparent():XSocket<Dynamic> {
		#if flash
		return untyped __as__(parent, XSocket);
		#else
		return cast parent;
		#end
	}
	
	override private function init():Void 
	{
		//trace(321);
		send('<?xsocket?>');
		xw.run(close);
	}
	
	public function set(name:String, value:Dynamic):Void {
		var x:Xml = Xml.createElement('set');
		x.set('name', name);
		x.addChild(Xml.createPCData(Serializer.run(value)));
		//trace(x);
		send(x.toString());
	}
	
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
	
	public function call(name:String, args:Array<Dynamic> = null, f:Dynamic->Void = null):Void {
		if (args == null) args = [];
		var x:Xml = Xml.createElement('call');
		x.set('name', name);
		x.addChild(Xml.createPCData(Serializer.run(args)));
		if (f != null)
			callwaits.push({n:name, f:f});
		send(x.toString());
	}
	
	override private function onData(d:String):Void 
	{
		if (xw != null) {
			xw.abort();
			xw = null;
			if (d != '<?xsocket?>') {
				close();
				if (parent.mode == 'client')
					parent.sockError();
			}
			else parent.socketInit(this);
			return;
		}
		
		var x:Xml;
		try {
			x = Xml.parse(d);
		} catch (e:Dynamic) {
			super.onData(d);
			return;
		}
		for (e in x) {
			if ((e.nodeType + '').toLowerCase() == 'element') { 
				switch (e.nodeName) {
					case 'get':
						untyped xParent.xGet(e.get('name'), respF(e.get('name'), 'get'));
					case 'set':
						untyped xParent.xSet(e.get('name'), e.firstChild());
					case 'call':
						untyped xParent.xCall(e.get('name'), e.firstChild(), respF(e.get('name'), 'call'));
					case 'response':
						switch (e.get('request')) {
							case 'get':
								getResponse(e.get('name'), e.firstChild());
							case 'call':
								callResponse(e.get('name'), e.firstChild());
						}
				}
			} else super.onData(e.toString());
		}
	}
	
	private function respF(n:String, t:String):Dynamic return function(v:Xml) response(n, t, v)
	
	private function response(n:String, type:String, v:Xml):Void {
		var x:Xml = Xml.createElement('response');
		x.set('request', type);
		x.set('name', n);
		x.addChild(v);
		send(x.toString());
	}
	
	private function getResponse(n:String, x:Xml):Void {
		if (getwaits.exists(n)) {
			var v:Dynamic = Unserializer.run(x.nodeValue);
			for (f in getwaits.get(n)) f(v);
			getwaits.remove(n);
		}
	}
	
	private function callResponse(n:String, x:Xml):Void {
		var v:Dynamic = Unserializer.run(x.nodeValue);
		var nclw:Array<{n:String, f:Dynamic->Void}> = [];
		while (callwaits.length>0) {
			var e: { n:String, f:Dynamic->Void } = callwaits.pop();
			if (e.n == n) e.f(v);
			else nclw.push(e);
		}
		callwaits = nclw;
	}
	
}