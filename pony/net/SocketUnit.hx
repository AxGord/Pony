package pony.net;

/**
 * ...
 * @author AxGord
 */

#if nodejs
typedef SocketUnit = pony.net.platform.nodejs.SocketUnit;
#else
typedef SocketUnit = null;
#end