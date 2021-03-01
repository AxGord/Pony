package pony.net.rpc;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import pony.magic.HasSignal;
import pony.events.Signal1;

/**
 * RPCUnit
 * @author AxGord <axgord@gmail.com>
 */
class RPCUnit<T:pony.net.rpc.IRPC> extends RPCBase<T> implements HasSignal {

	@:auto public var onData:Signal1<Bytes>;
	private function send():Void eData.dispatch(pack());
	public function data(b:Bytes):Void dataHandler(new BytesInput(b));

}