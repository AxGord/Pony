/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;

/**
 * INet
 * @author DIS
 * @author AxGord <axgord@gmail.com>
 */
interface INet 
{
	#if !flash
	/**
	 * onAccept in a server
	 */
	var onConnect(get, null):Signal1<SocketClient>;
	var onOpen(get, null):Signal0;
	
	var onData(get, null):Signal2<BytesInput, SocketClient>;
	var onString(get, null):Signal2<String, SocketClient>;
	
	var onClose(get, null):Signal0;
	var onDisconnect(get, null):Signal1<SocketClient>;
	
	var opened(default,null):Bool;
	
	var isWithLength:Bool;
	
	function send(b:BytesOutput):Void;
	function sendString(s:String):Void;
	function destroy():Void;
	#end
}