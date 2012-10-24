package pony.net.platform.flash;

import pony.net.SocketBase;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
//import flash.system.Security;
/**
 * ...
 * @author AxGord
 */

class Socket extends SocketBase
{

	override private function _connect(host:String, port:Int):Void {
		var s:flash.net.Socket = new flash.net.Socket(host, port);
		s.addEventListener(Event.CONNECT, function(event:Event) {
			if (enabled)
				createSocket(s);
			else {
				s.close();
			}
		});
		s.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent) sockError());
        s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}
	
	private function securityErrorHandler(e:SecurityErrorEvent):Void {
		trace('securityError(mb need focus?)');
	}
	
	private function createSocket(o:flash.net.Socket ):Void {
		new SocketUnit(sockets.length, this, o);
	}
	
}