/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.cs;
#if cs
import cs.system.IAsyncResult;
import cs.system.net.sockets.AddressFamily;
import cs.system.net.sockets.ProtocolType;
import cs.system.net.sockets.SocketType;
import cs.system.net.IPEndPoint;
import cs.system.net.IPAddress;
import cs.system.net.sockets.Socket;
import pony.net.SocketServerBase;

/**
 * SocketServer
 * @author AxGord <axgord@gmail.com>
 */
class SocketServer extends SocketServerBase {

	private var listener:Socket;
	
	public function new(port:Int) {
		super();
		listener = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
		listener.Bind(new IPEndPoint(IPAddress.Any, port));
		listener.Listen(100);
		trace('Port: '+port);
		waitAccept();
	}
	
	private function waitAccept():Void {
		listener.BeginAccept(untyped __cs__('acceptCallback'), null);
	}


	private function acceptCallback(ar:IAsyncResult):Void {
		trace('accept');
		addClient().initCS(listener.EndAccept(ar));
		waitAccept();
	}

	override public function close():Void 
	{
		listener.Close();
		listener = null;
		super.close();
	}
}
#end