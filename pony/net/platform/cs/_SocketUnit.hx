package pony.net.platform.cs;

import cs.NativeArray;
import dotnet.system.FlagsAttribute;
import pony.events.Signal;
import pony.magic.Declarator;
import dotnet.system.Byte;
import dotnet.system.IAsyncResult;
import dotnet.system.net.sockets.SocketFlags;
import dotnet.system.net.sockets.SelectMode;
import dotnet.system.net.sockets.SocketShutdown;
import dotnet.system.text.Encoding;

/**
 * ...
 * @author AxGord
 */

class _SocketUnit implements Declarator
{
	@arg public var id:Int;
	@arg private var parent:_Socket;
	@arg private var socket:dotnet.system.net.sockets.Socket;
	
	public var DATA:Signal = new Signal();
	public var CLOSE:Signal = new Signal();
	
	public var bufferSize:Int = 1024;
	private var buffer:NativeArray<Byte> = new NativeArray<Byte>(bufferSize);
	
	private var closed:Bool = false;
	
	public function new() {
		waitData();
		init();
	}
	
	private function init():Void {
		parent.socketInit(this);
	}
	
	private function waitData():Void {
		socket.BeginReceive(buffer, 0, bufferSize, SocketFlags.None, untyped __cs__('readCallback'), null);
	}
	
	private function readCallback(ar:IAsyncResult):Void {
		
		if (closed) return;
		
		var bytesRead:Int = socket.EndReceive(ar);
		if (bytesRead > 0) {
			var content:String = Encoding.UTF8.GetString(buffer, 0, bytesRead);
			onData(content);
		}
		
		
		if (socketConnected(socket)) {
			waitData();
		} else {
			closed = true;
			onClose();
			socket.Shutdown(SocketShutdown.Both);
			
			socket.BeginDisconnect(true, untyped __cs__('disconnectCallback'), socket);
		}
	}
	
	private function disconnectCallback(ar:IAsyncResult):Void {
		socket.EndDisconnect(ar);
		socket.Close();
	}
	
	private function onData(d:String):Void {
		DATA.dispatch(d);
		parent.dispatch(pony.net.Socket.DATA, this, d);
	}
	
	private function onClose():Void {
		trace('close socket');
		CLOSE.dispatch();
		parent.dispatch(pony.net.Socket.CLOSE_SOCKET, this);
	}
	
	
	private static function socketConnected(s:dotnet.system.net.sockets.Socket):Bool {
		var part1:Bool = s.Poll(1000, SelectMode.SelectRead);
		var part2:Bool = s.Available == 0;
		return !(part1 && part2);
	}
	
	public function send(data:String):Void {
		var b:NativeArray<Byte> = Encoding.UTF8.GetBytes(data);
		socket.BeginSend(b, 0, b.Length, SocketFlags.None, untyped __cs__('sendCallback'), null);
	}
	
	private function sendCallback(ar:IAsyncResult):Void {
		socket.EndSend(ar);
		//trace('sended');
	}
	
	public function close():Void {
		if (closed) return;
		closed = true;
		onClose();
		socket.Shutdown(SocketShutdown.Both);
		//socket.Close();
		socket.BeginDisconnect(true, untyped __cs__('disconnectCallback'), socket);
		
	}
	
}