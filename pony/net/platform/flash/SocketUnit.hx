package pony.net.platform.flash;

import pony.events.Signal;
import pony.magic.Declarator;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;

/**
 * ...
 * @author AxGord
 */

class SocketUnit implements Declarator
{

	@arg public var id:Int;
	@arg private var parent:pony.net.Socket;
	@arg private var socket:Dynamic;

	public var DATA:Signal = new Signal();
	public var CLOSE:Signal = new Signal();
	
	public function new() 
	{
		socket.addEventListener(Event.CLOSE, onClose);
		socket.addEventListener(ProgressEvent.SOCKET_DATA, _onData);
		socket.addEventListener(IOErrorEvent.IO_ERROR, _close);
		init();
	}
	
	private function init():Void {
		parent.socketInit(this);
	}
	
	private function _onData(event:ProgressEvent):Void {
		onData(new String(socket.readUTFBytes(socket.bytesAvailable)));
	}
	
	private function onData(d:String):Void {
		DATA.dispatch(d);
		parent.dispatch(pony.net.Socket.DATA, this, d);
	}
	
	public function send(data:String):Void {
		if (socket != null) {
			socket.writeUTFBytes(data);
			socket.flush();
		}
	}
	
	public function _close(event:Dynamic):Void close()
	
	public function close():Void {
		if (socket == null) return;
		socket.close();
		socket = null;
		onClose();
	}
	
	private function onClose(?event:Dynamic):Void {
		CLOSE.dispatch();
		parent.dispatch('closeSocket', this);
	}
	
}