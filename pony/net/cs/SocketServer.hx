package pony.net.cs;
#if cs
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.events.Signal;
import pony.events.Signal1.Signal1;
import pony.net.SocketServerBase;
import cs.system.net.sockets.Socket;

/**
 * SocketServer
 * A class wrapping an async-based C# server.
 * @author DIS
 **/
class SocketServer extends SocketServerBase
{
	private var server:CSServer;
	
	/**
	 * Creats a new server.
	 **/
	public function new(port:Int):Void 
	{
		super();
		server = new CSServer(port);
		server.onData << function(b_in:BytesInput)
		{
			onData.dispatch(b_in);
		}
		
		server.onAccept << function(socket:Socket)
		{
			var cl:SocketClient = addClient();
			cl.socket = socket;
			cl.isFromServer = true;
			onConnect.dispatch(cl);
		};
	}
	
	/**
	 * Closes a server and destroys signals.
	 **/
	public override function destroy():Void
	{
		server.stop();
		super.destroy();
		server = null;
	}
	/*
	 * Здесь принято следующее именование:
		 * названия сигналов в формате onVerb, где Verb - глагол настоящего простого времени в первом лице; исключение - сигнал на получение данных (onData);
		 * названия переменных и функций записаны в стиле lowerCamelCase; нижнее подчёркивание - только в переменных b_in(BytesInput) и b_out(BytesOutput);
		 * названия классов записаны в стиле UpperCamelCase;
		 * названия интерфейсов записаны с использованием венгерской нотации, префикс "I" (interface);
		 * названия аргументов функций, если они совпадают с полями класса или предка, записаны в венгерской нотации, префикс "a" (argument);
		 */
}
#end