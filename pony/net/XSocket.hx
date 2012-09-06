package pony.net;
import pony.net.SocketUnit;
import pony.XMLTools;

/**
 * ...
 * @author AxGord
 */

class XSocket extends Socket
{
	@arg public var target:Dynamic = null;
	
	public var xsockets(getXSockets, null):Array<XSocket>;

	private var gw:Array<{n: String, f: String->Void}> = [];
	
	
	override private function init() {
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
	
	override private function createSocket(o:Dynamic):SocketUnit 
	{
		var x:XSocketUnit = new XSocketUnit(sockets.length, untyped this, o);
		return cast x;
	}
	
	private function onActive():Void {
		for (o in gw) get(o.n, o.f);
	}
	
	public function xGet(v:String, f:Xml->Void):Void {
		trace('get: ' + v);
		f(XMLTools.serialize(Reflect.field(target, v)));
	}
	
}