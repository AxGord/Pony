/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import haxe.io.BytesInput;
import haxe.io.BytesOutput;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
#if (!js || nodejs)
class SocketClient
#if nodejs
extends pony.net.nodejs.SocketClient
#elseif cs
extends pony.net.cs.SocketClient
#elseif flash
extends pony.net.flash.SocketClient
#elseif openfl
extends pony.net.openfl.SocketClient
#end
implements ISocketClient {
	
	public var writeLengthSize:UInt;
	
	private var stack:Array<BytesOutput>;
	
	override function sharedInit():Void {
		writeLengthSize = 4;
		stack = [];
		super.sharedInit();
	}
	
	#if !cs//Not working for CS
	dynamic public function writeLength(bo:BytesOutput, length:UInt):Void bo.writeInt32(length);
	#end
	override public function send(data:BytesOutput):Void {
		if (!opened) {
			stack.push(data);
			return;
		}
		var len:UInt = data.length;
		var needSplit = maxSize != 0 && len > maxSize;
		if (isWithLength || needSplit) {
			var bo = new BytesOutput();
			#if cs
			if (isWithLength) bo.writeInt32(len);
			#else
			if (isWithLength) writeLength(bo, len);
			#end
			if (needSplit) {
				if (isWithLength && maxSize > 4 + writeLengthSize) maxSize -= writeLengthSize;
				var b = new BytesInput(data.getBytes());
				while (len >= maxSize) {
					bo.write(b.read(maxSize));
					len -= maxSize;
				}
				if (len > 0) bo.write(b.read(len));
			} else {
				bo.write(data.getBytes());
			}
			super.send(bo);
		} else {
			super.send(data);
		}
	}
	
	public function sendString(data:String):Void {
		var bo = new BytesOutput();
		bo.writeString(data);
		send(bo);
	}
	
	public function sendStack():Void {
		if (stack.length > 0) send(stack.shift());
	}
	
	public function sendAllStack():Void {
		while (stack.length > 0) send(stack.shift());
	}
	
}
#else
typedef SocketClient = SocketClientBase;
#end