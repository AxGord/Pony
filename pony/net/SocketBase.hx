package pony.net;

import pony.Enabler;
import pony.Intervals;
import pony.magic.Binder;
import pony.SpeedLimit;

/**
 * ...
 * @author AxGord
 */

class SocketBase extends Enabler, implements Binder
{
	public var mode(default, null):String = '';
	public var sockets(default, null):Array<SocketUnit>;
	
	public var active(default, null):Bool = false;
	
	private var host:String;
	private var port:Intervals;
	private var portIt:Iterator<Int>;
	private var sl:SpeedLimit;
	private var lastPort:Int;
	
	private var wq:String= '';
	
	/**
	 * Reconnect timeout
	 */
	@bind public var retime:Int = sl.delay;

	public function new(_retime:Int=500, delay:Int=-1) 
	{
		sockets = [];
		super(true, delay);
		sl = new SpeedLimit(_retime);
		addListener(Enabler.ON, onEnable);
		addListener(Enabler.OFF, onDisable);
		addListener('closeSocket', onSocketClose);
		init();
	}
	
	private function init():Void {}
	
	public function listen(port:Dynamic):Void {
		if (mode == 'client') throw 'This socket not for server';
		mode = 'server';
		this.port = new Intervals(port);
		if (enabled) {
			portIt = this.port.iterator();
			bindn();
		}
	}
	
	private inline function bindn():Void bind(lastPort = portIt.next())
	
	private function bind(port:Int):Void {
		throw 'Not support on this platform';
	}
	
	private function bindFail():Void {
		if (portIt.hasNext()) {
			message('Error bind on ' + lastPort + ' port, try next port');
			bindn();
		} else {
			message('Error bind on ' + lastPort + ' port, try again after ' + sl.delay + ' ms');
			portIt = this.port.iterator();
			sl.run(bindn);
		}
	}
	
	
	private function socketUnit(s:SocketUnit):Void {
		sockets.push(s);
	}
	
	private function binded():Void {
		active = true;
		message('Binded on localhost:' + lastPort);
		dispatch(Socket.BINDED);
		dispatch(Socket.ACTIVE);
	}
	
	private function onClose():Void {
		active = false;
		message('Close server');
	}
	
	private function onEnable():Void {
		portIt = port.iterator();
		if (mode == 'server') {
			bind(lastPort);
		} else if (mode == 'client') {
			connect(lastPort);
		}
	}
	
	private function onDisable():Void {
		active = false;
		if (mode == 'server') {
			servClose();
		} else if (mode == 'client') {
			for (s in sockets) untyped s.close();
		}
	}
	
	
	private function servClose():Void {}
	
	public function connect(host:String = 'localhost', port:Dynamic=6001):Void {
		if (mode == 'server') throw 'This server';
		mode = 'client';
		this.host = host;
		this.port = new Intervals(port);
		if (enabled) {
			portIt = this.port.iterator();
			conNext();
		}
	}
	
	private inline function conNext():Void _connect(host, lastPort = portIt.next())
	
	private function _connect(host:String, port:Int):Void {}
	
	public function sockError():Void {
		if (portIt.hasNext()) {
			message('Error connect on ' + lastPort + ' port, try next port');
			conNext();
		} else {
			message('Error connect on ' + lastPort + ' port, try again after ' + sl.delay + ' ms');
			portIt = this.port.iterator();
			sl.run(conNext);
		}
	}
	
	public function socketInit(s:SocketUnit):Void {
		socketUnit(s);
		active = true;
		dispatch('connect');
		dispatch('active');
		message('Connected');
	}
	
	private function onSocketClose(s:SocketUnit):Void {
		message('Close socket #' + s.id);
		sockets.remove(s);
		if (mode == 'client') {
			active = false;
			sl.run(conNext);
		}
	}
	
	public function send(data:String):Void {
		if (mode == '') throw 'Socket not ready';
		if (mode == 'client' && !active) {
			wq += data;
			addListener('connect', sendQ);
		} else
			for (s in sockets) s.send(data);
	}
	
	private function sendQ():Void {
		send(wq);
		wq = '';
	}
	
	
}