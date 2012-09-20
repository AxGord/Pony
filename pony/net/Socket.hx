package pony.net;

/**
 * ...
 * @author AxGord
 */

class Socket
#if nodejs
extends pony.net.platform.nodejs.Socket
#elseif flash
extends pony.net.platform.flash.Socket
#end
{
	static public var DATA:String = 'data';
	static public var CLOSE_SOCKET:String = 'closeSocket';
	static public var BINDED:String = 'binded';
	static public var CONNECT:String = 'connect';
	static public var ACTIVE:String = 'active';
	
}
 
