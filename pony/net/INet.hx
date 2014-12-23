package pony.net;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import pony.events.*;
/**
 * INet
 * @author DIS
 */
interface INet 
{
	var id(default,null):Int;
	var onData(default, null):Signal1<SocketClient, BytesInput>;
	var isAbleToSend:Bool;
	var isWithLength:Bool;
	var onConnect(default, null):Signal1<SocketServer, SocketClient>; //onAccept in a server.
	var onDisconnect(default,null):Signal;
	function send(b:BytesOutput):Void;
	function destroy():Void;
}