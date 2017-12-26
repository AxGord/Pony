package pony.net.rpc;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import haxe.io.Bytes;

/**
 * RPCUnit
 * @author AxGord <axgord@gmail.com>
 */
class RPCUnit<T:pony.net.rpc.IRPC> extends RPCBase<T> {

	private function new() super();
	private function send():Void {
		var b = pack();
		trace(b.length);
		onData(b);
	}
	public dynamic function onData(data:Bytes):Void {}
	public function data(b:Bytes):Void {
		trace(b.length);
		dataHandler(new BytesInput(b));
	}
}