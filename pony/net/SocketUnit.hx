package pony.net;

/**
 * ...
 * @author AxGord
 */

#if nodejs
typedef SocketUnit = pony.net.platform.nodejs.SocketUnit;
#elseif flash
typedef SocketUnit = pony.net.platform.flash.SocketUnit;
#elseif cs
typedef SocketUnit = pony.net.platform.cs._SocketUnit;
#end