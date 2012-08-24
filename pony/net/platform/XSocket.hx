/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/

package pony.net.platform;
import flash.events.Event;
import flash.net.XMLSocket;
import flash.xml.XML;
import pony.events.Dispatcher;
import pony.Ultra;

/**
 * @author AxGord
 */
 
class XSocket extends Dispatcher
{
	private var host:String = null;
	private var port:Int = Ultra.nullInt;
	
	static public var CONNECT:String = 'connect';
	static public var CLOSE:String = 'close';
	
	public var enabled(getEnabled, setEnabled):Bool;
	private var _enabled = false;
	public var active:Bool = false;
	private var socket:XMLSocket;

	public function new(?host:String, port:Int = Ultra.nullInt) 
	{
		this.host = host;
		this.port = port;
		if (port != Ultra.nullInt)
			_enabled = true;
		socket = new XMLSocket(host, port);
		trace(host);
		socket.addEventListener(Event.CONNECT, onConnect);
		socket.addEventListener(Event.CLOSE, onClose);
		super();
	}
	
	private function getEnabled():Bool {
		return _enabled;
	}
	
	private function setEnabled(b:Bool):Bool {
		if (b == _enabled) return b;
		if (b) {
			socket.close();
			active = false;
		} else
			connect();
		return _enabled = b;
	}
	
	private function onConnect(event:Event):Void {
		active = true;
		dispatch(CONNECT);
	}
	
	private function onClose(event:Event):Void {
		active = false;
		dispatch(CLOSE);
	}
	
	public inline function connect(?host:String, ?port:Int):Void
	{
		if (port != null) {
			this.host = host;
			this.port = port;
		}
		socket.connect(host, port);
	}
	
	public inline function send(text:String):Void {
		socket.send(text);
	}
	
	public function get(name:String):Void {
		send((new XML('<get name="'+name+'"/>')).toString());
	}
	
}