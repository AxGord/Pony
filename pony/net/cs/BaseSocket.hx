package pony.net.cs;
#if cs
import cs.NativeArray.NativeArray;
import cs.system.net.sockets.Socket;
import cs.system.net.sockets.SocketAsyncEventArgs;
import cs.system.net.sockets.SocketShutdown;
import cs.system.net.sockets.SocketException;
import cs.system.EventHandler_1;
import cs.system.Console;
import cs.types.UInt8;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import cs.system.Object;
import haxe.io.BytesOutput;
import pony.events.Signal;
import pony.events.Signal1;

/**
 * BaseSocket
 * @author DIS
 */


class BaseSocket 
{
	
	@:allow(pony.net.cs.SocketClient)
	private static function baseSend(addressee:Socket, data:BytesOutput, ?e:SocketAsyncEventArgs)
	{
		if (e == null)
		{
			e = new SocketAsyncEventArgs();
		}
		
		var sendBuffer:NativeArray<UInt8> = new NativeArray(data.length);
		var b_in:BytesInput = new BytesInput(data.getBytes());
		for (i in 0...sendBuffer.Length) sendBuffer[i] = b_in.readByte();
		e.SetBuffer(sendBuffer, 0, sendBuffer.Length);
		Sys.sleep(0.005);
		e.add_Completed(new EventHandler_1<SocketAsyncEventArgs>(onSend));
		addressee.SendAsync(e);
	}
	
	private static function onSend(sender:Object, e:SocketAsyncEventArgs):Void
	{
		if (e.SocketError != cs.system.net.sockets.SocketError.Success)
		{
			processError(e);
		}
	}
	
	private static function processError(e:SocketAsyncEventArgs):Void
	{
		var s:Socket = cast e.UserToken;
		if (s.Connected)
		{
			try
			{
				s.Shutdown(SocketShutdown.Both);
			}
			catch (_:Dynamic)
			{
				trace("The socket has already been closed.");
			}
			s.Close();
		}
		throw new SocketException();
	}
	
}
#end