package pony.net.rpc;

import haxe.io.BytesOutput;
import pony.magic.HasSignal;
import pony.net.INet;

/**
 * IRPC - Remove Procedure Call Build System
 * -lib hxbit
 * use with IRPC
 * @author AxGord <axgord@gmail.com>
 */
class RPC<T:IRPC> extends RPCBase<T> implements HasSignal {

	public var socket: INet;

	public function new(s: INet) {
		super();
		socket = s;
		s.onData << dataHandler;
		#if (!js || nodejs)
		@SuppressWarnings('checkstyle:MagicNumber')
		#if (haxe_ver >= 4.10)
			if (Std.isOfType(s, pony.net.SocketClient))
			#else
			if (Std.is(s, pony.net.SocketClient))
			#end
		{
			final sc: pony.net.SocketClient = cast s;
			sc.onConnect << sc.sendAllStack;
		}
		#end
	}

	private function send(): Void {
		final bo: BytesOutput = new BytesOutput();
		bo.write(pack());
		socket.send(bo);
	}

}
