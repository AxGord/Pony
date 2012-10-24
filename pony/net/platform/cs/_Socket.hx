package pony.net.platform.cs;

import dotnet.system.IAsyncResult;
import dotnet.system.net.sockets.AddressFamily;
import dotnet.system.net.sockets.ProtocolType;
import dotnet.system.net.sockets.SocketType;
import dotnet.system.net.IPEndPoint;
import dotnet.system.net.IPAddress;
import pony.net.SocketBase;

/**
 * ...
 * @author AxGord
 */

class _Socket extends SocketBase
{
	private var listener:dotnet.system.net.sockets.Socket;
	
	override private function bind(port:Int):Void {
		if (listener == null)
			listener = new dotnet.system.net.sockets.Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
			
		try {
			listener.Bind(new IPEndPoint(IPAddress.Any, port));
			listener.Listen(100);
			waitAccept();
			binded();
		} catch (e:Dynamic) {
			bindFail();
		}
	}
		
	private function waitAccept():Void {
		listener.BeginAccept(untyped __cs__('acceptCallback'), null);
	}
	
	private function acceptCallback(ar:IAsyncResult):Void {
		trace('accept');
		createSocket(listener.EndAccept(ar));
		waitAccept();
	}
	
	
	private function createSocket(o:dotnet.system.net.sockets.Socket):Void {
		new SocketUnit(sockets.length, this, o);
	}
}