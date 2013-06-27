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
		s.addEventListener(Event.CONNECT, onConnect);
		s.addEventListener(IOErrorEvent.IO_ERROR, ioError);
        s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}
	
	private function onConnect(event:Event):Void {
		if (enabled)
			createSocket(cast(event.target, flash.net.Socket));
		else {
			event.target.close();
		}
	}
	
	private function ioError(event:IOErrorEvent):Void {
		removeListeners(cast(event.target, flash.net.Socket));
		sockError();
	}
	
	private function removeListeners(s:flash.net.Socket):Void {
		s.removeEventListener(Event.CONNECT, onConnect);
		s.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
        //s.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}
	
	private function securityErrorHandler(e:SecurityErrorEvent):Void {
		removeListeners(cast(e.target, flash.net.Socket));
		trace('securityError(mb need focus?)');
	}
	
	private function createSocket(o:flash.net.Socket ):Void {
		new SocketUnit(sockets.length, this, o);
	}
	
}