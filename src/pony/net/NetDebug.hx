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

	private static var trstr: String = '';

	#if !flash
	public static inline function server(port: Int = 60666): Void
		new SocketServer(port).onData << function(d: BytesInput) Log.trace(d.readStr(), null);
	#end

	public static function client(name: String, ?host: String, port: Int = 60666): Void {
		var c: SocketClient = new SocketClient(host, port);
		var old = Log.trace;
		Log.trace = function(d: Dynamic, ?p: PosInfos): Void {
			old(d, p);
			if (trstr != '') trstr += '\n';
			trstr += name + ' => ' + (p == null ? '' : p.fileName + ':' + p.lineNumber + ': ') + Std.string(d);
		}
		DeltaTime.fixedUpdate << function(): Void if (trstr != '') {
			var b: BytesOutput = new BytesOutput();
			b.writeStr(trstr);
			trstr = '';
			c.send(b);
		}
	}

}