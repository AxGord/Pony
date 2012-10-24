package pony.net;

import haxe.Serializer;
import haxe.Unserializer;
import pony.net.SocketUnit;
import pony.XMLTools;

/**
 * ...
 * @author AxGord
 */

class XSocket<T> extends Socket
{
	public var target:Dynamic;
	
	public var xsockets(getXSockets, null):Array<XSocketUnit>;

	private var gw:Array<{n: String, f: Dynamic->Void}>;
	private var sw:Array<{n: String, v: Dynamic}>;
	private var cw:Array<{n: String, args:Array<Dynamic>, f: Dynamic->Void}>;
	
	public function new(_retime:Int=500, delay:Int=-1, ?target:T) {
		this.target = target;
		super(_retime, delay);
	}
	
	override private function init() {
		gw = [];
		sw = [];
		cw = [];
		addListener(Socket.ACTIVE, onActive);
	}
	
	private function getXSockets():Array<XSocketUnit> return untyped sockets
	
	public function setv(name:String, value:Dynamic):Void {
		if (active) {
			for (x in xsockets)
				x.set(name, value);
		} else
			sw.push( {n: name, v: value} );
	}
	
	public function get(name:String, f:Dynamic->Void):Void {
		if (active) {
			var b:Bool = true;
			for (x in xsockets)
				x.get(name, function(v:Dynamic) if (b) {
					b = false;
					f(v);
				});
		} else
			gw.push( { n:name, f:f } );
	}
	
	public function call(name:String, args:Array<Dynamic> = null, f:Dynamic->Void=null):Void {
		if (args == null) args = [];
		if (active) {
			for (x in xsockets)
				x.call(name, args, f);
		} else
			cw.push({n:name, args:args, f:f});
	}
	
	override private function createSocket(o:Dynamic):Void 
	{
		var x:XSocketUnit = new XSocketUnit(sockets.length, untyped this, o);
		//socketInit(cast x);
	}
	
	private function onActive():Void {
		for (o in sw) setv(o.n, o.v);
		sw = [];
		for (o in cw) call(o.n, o.args, o.f);
		cw = [];
		for (o in gw) get(o.n, o.f);
		gw = [];
	}
	
	public function xGet(v:String, f:Xml->Void):Void {
		f(Xml.createPCData(Serializer.run(Reflect.field(target, v))));
	}
	
	public function xSet(v:String, val:Xml):Void {
		Reflect.setField(target, v, Unserializer.run(val.nodeValue));
	}
	
	public function xCall(v:String, args:Xml, f:Xml->Void):Void {
		var r:Dynamic = Reflect.callMethod(target, Reflect.field(target, v), Unserializer.run(args.nodeValue));
		f(Xml.createPCData(Serializer.run(r)));
		//f(Xml.createPCData(Serializer.run(Reflect.field(target, v))));
	}
	
}