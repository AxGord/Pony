package pony.net;

import pony.net.SocketUnit;
import pony.XMLTools;

/**
 * ...
 * @author AxGord
 */

class XSocket extends Socket
{
	public var target:Dynamic;
	
	public var xsockets(getXSockets, null):Array<XSocket>;

	private var gw:Array<{n: String, f: String->Void}>;
	
	public function new(_retime:Int=500, delay:Int=-1, ?target:Dynamic) {
		this.target = target;
		super(_retime, delay);
	}
	
	override private function init() {
		gw = [];
		addListener(Socket.ACTIVE, onActive);
	}
	
	private function getXSockets():Array<XSocket> return untyped sockets
	
	public function get(name:String, f:Dynamic->Void):Void {
		if (active) {
			var b:Bool = true;
			for (x in xsockets)
				x.get(name, function(v:String) if (b) {
					b = false;
					f(v);
				});
		} else
			gw.push( { n:name, f:f } );
	}
	
	override private function createSocket(o:Dynamic):Void 
	{
		var x:XSocketUnit = new XSocketUnit(sockets.length, untyped this, o);
		//socketInit(cast x);
	}
	
	private function onActive():Void {
		for (o in gw) get(o.n, o.f);
	}
	
	public function xGet(v:String, f:Xml->Void):Void {
		trace('get: ' + v);
		f(XMLTools.serialize(Reflect.field(target, v)));
	}
	
}