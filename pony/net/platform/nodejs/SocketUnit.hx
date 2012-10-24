package pony.net.platform.nodejs;

//import js.Node;
import pony.events.Signal;
import pony.magic.Declarator;

/**
 * ...
 * @author AxGord
 */

class SocketUnit implements Declarator
{
	@arg public var id:Int;
	@arg private var parent:Socket;
	@arg private var socket:Dynamic;// NodeNetSocket;

	public var DATA:Signal = new Signal();
	public var CLOSE:Signal = new Signal();
	
	public function new() 
	{
		socket.on('data', _onData);
		socket.on('close', onClose);
		socket.on('error', close);
		init();
	}
	
	private function init():Void {
		parent.socketInit(this);
	}
	
	private function _onData(d:Dynamic):Void {
		onData(new String(d));
	}
	
	private function onData(d:String):Void {
		DATA.dispatch(d);
		parent.dispatch(pony.net.Socket.DATA, this, d);
	}
	
	public function send(data:String):Void {
		if (socket != null)
			socket.write(data);
	}
	
	public function close():Void {
		if (socket == null) return;
		socket.end();
		socket.destroy();
		socket = null;
		onClose();
	}
	
	private function onClose():Void {
		CLOSE.dispatch();
		parent.dispatch(pony.net.Socket.CLOSE_SOCKET, this);
	}
	
}