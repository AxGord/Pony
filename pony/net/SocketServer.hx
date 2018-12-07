/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.net;

import haxe.io.BytesOutput;

/**
 * SocketServer
 * @author AxGord <axgord@gmail.com>
 */
#if (!js||nodejs)
class SocketServer
#if nodejs
extends pony.net.nodejs.SocketServer
#elseif cs
extends pony.net.cs.SocketServer
#elseif neko
extends pony.net.neko.SocketServer
#else
extends pony.net.SocketServerBase
#end
#if !flash
implements ISocketServer
#end
{
	#if !flash
	public function new(port:Int, isWithLength:Bool = true, maxSize:Int = 1024) {
		super(port);
		this.isWithLength = isWithLength;
		this.maxSize = maxSize;
	}
	#end
	public inline function sendString(data:String):Void {
		var bo = new BytesOutput();
		bo.writeString(data);
		send(bo);
	}
	
	override public function destroy():Void {
		if (opened) super.destroy();
		else if (onOpen != null) onOpen << destroy;
	}
	
}
#end