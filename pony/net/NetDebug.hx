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
import haxe.Log;
import haxe.PosInfos;
import pony.time.DeltaTime;
using pony.Tools;
/**
 * Net Debug
 * Use TCP-IP for debug applications
 * @author AxGord <axgord@gmail.com>
 */
class NetDebug {
	#if !flash
	inline public static function server(port:Int=60666) new SocketServer(port).onData << function(d:BytesInput) Log.trace(d.readStr(), null);
	#end
	
	private static var trstr:String = '';
	
	public static function client(name:String, ?host:String, port:Int=60666) {
		var c = new SocketClient(host, port);
		var old = Log.trace;
		Log.trace = function(d:Dynamic, ?p:PosInfos):Void {
			old(d, p);
			if (trstr != '') trstr += '\n';
			trstr += name + ' => ' + (p == null ? '' : p.fileName+':' + p.lineNumber + ': ') + Std.string(d);
		}
		DeltaTime.fixedUpdate << function():Void if (trstr != '') {
			var b = new BytesOutput();
			b.writeStr(trstr);
			trstr = '';
			c.send(b);
		}
	}
	
}