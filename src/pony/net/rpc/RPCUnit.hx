package pony.net.rpc;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import pony.events.Signal1;
import pony.magic.HasSignal;

/**
 * RPCUnit
 * @author AxGord <axgord@gmail.com>
 */
class RPCUnit<T:pony.net.rpc.IRPC> extends RPCBase<T> implements HasSignal {

	@:auto public var onData: Signal1<Bytes>;

	public function data(b: Bytes): Void dataHandler(new BytesInput(b));

	private function send(): Void eData.dispatch(pack());

}
