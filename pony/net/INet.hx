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
	//var id(default,null):Int;
	var onData(default, null):Signal1<SocketClient, BytesInput>;
	var isAbleToSend:Bool;
	var isWithLength:Bool;
	var onDisconnect(default,null):Signal0<SocketClient>;
	function send(b:BytesOutput):Void;
	function destroy():Void;
}