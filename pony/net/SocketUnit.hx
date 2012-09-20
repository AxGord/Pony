package pony.net;

/**
 * ...
 * @author AxGord
 */

#if nodejs
typedef SocketUnit = pony.net.platform.nodejs.SocketUnit;
#elseif flash
typedef SocketUnit = pony.net.platform.flash.SocketUnit;
#else
//typedef SocketUnit = null;
#end