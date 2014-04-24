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
	var data(default, null):Signal1<SocketClient, BytesInput>;
	var disconnect(default,null):Signal;
	function send(b:BytesOutput):Void;
	function close():Void;
}