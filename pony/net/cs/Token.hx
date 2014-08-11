package pony.net.cs;
#if cs
import cs.system.IDisposable;
import cs.system.net.sockets.Socket;
import cs.system.net.sockets.SocketShutdown;
import cs.system.net.sockets.SocketAsyncEventArgs;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;

/**
 * Token
 * @author DIS
 */
class Token implements IDisposable
{

 public var connection:Socket;

 public function new(aConnection:Socket)
 {
	this.connection = aConnection;
 }
 
 public function setData(args:SocketAsyncEventArgs):BytesInput
 {
	var b_out = new BytesOutput();
	var count:Int = args.BytesTransferred;
	var buf:BytesOutput = new BytesOutput();
	for (i in 0...args.Buffer.Length) buf.writeByte(args.Buffer[i]);
	var b:Bytes = buf.getBytes();
	var b_in:BytesInput = new BytesInput(b);
	return b_in;
 }
 
 public function Dispose():Void
 {
	try
	{
		this.connection.Shutdown(SocketShutdown.Send);
	}
	catch (_:Dynamic)
	{
	}
	this.connection.Close();
 }
 
 
}
#end