package pony.net;

import com.dongxiguo.protobuf.binaryFormat.LimitableBytesInput;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Timer;
import pony.events.Signal0;
import pony.magic.Declarator;
import pony.Queue;
import pony.time.DeltaTime;

typedef ProtobufBuilder = {
	function new(): Void;
}

/**
 * Protobuf helper
 * @author AxGord <axgord@gmail.com>
 */
@:generic
class Protobuf<A:ProtobufBuilder, B:ProtobufBuilder> implements Declarator {

	@:arg public var socket(default, null): INet;

	@:arg private var awrite: A -> BytesOutput -> Void;
	@:arg private var bmerge: B -> LimitableBytesInput -> Void;

	public var onData(default, null): Signal2<Protobuf<A, B>, B, INet> = Signal.create(this);
	public var onSend(default, null): Signal1<Protobuf<A, B>, A> = Signal.create(this);

	private var fs: List<A -> Void> = new List();

	private var gonext: Int = 0;

	public var sendComplite: Signal0<Protobuf<A, B>> = Signal.create(this);

	private var _queue: Queue<(A -> Void) -> Void>;

	public function new() {
		_queue = new Queue<(A -> Void) -> Void>(__queue);
		socket.onData.add(dataHandler);
		DeltaTime.fixedUpdate.add(trySend);
	}

	public inline function queue(f: A -> Void): Void _queue.call(f);

	private function __queue(f: A -> Void): Void {
		send(f);
		onSend < queueNext; // todo: fix problem
	}

	private function queueNext(): Void DeltaTime.skipUpdate(_queue.next);

	private function dataHandler(d: BytesInput, s: SocketClient): Void {
		var b: B = new B();
		bmerge(b, new LimitableBytesInput(d.readAll()));
		onData.dispatch(b, s);
	}

	public function send(f: A -> Void): Void {
		if (fs == null) fs = new List<A -> Void>();
		fs.push(f);
	}

	public function sendBuilder(b: A): Void
		send(function(nb: A) for (f in Reflect.fields(b)) Reflect.setField(nb, f, Reflect.field(b, f)));

	private function trySend(): Void {
		if (gonext > 0) {
			if (--gonext == 0) sendComplite.dispatch();
			return;
		}
		if (!socket.isAbleToSend) return;
		if (fs == null) return;
		if (fs.length == 0) return;
		if (socket == null) return;
		var builder: A = new A();
		onSend.dispatch(builder);
		for (f in fs) f(builder);
		fs = null;
		sendTo(builder, socket);
		// #if nodejs
		// gonext = 2;
		// #else
		gonext = 1;
		// #end
	}

	public function sendTo(builder: A, socket: INet): Void {
		var output: BytesOutput = new BytesOutput();
		awrite(builder, output);
		socket.send(output);
	}

	public function send2Other(builder: A, socket: SocketClient): Void {
		var output: BytesOutput = new BytesOutput();
		awrite(builder, output);
		socket.send2other(output);
	}

	public function destroy(): Void {
		DeltaTime.fixedUpdate.remove(trySend);
		socket.destroy();
		sendComplite.destroy();
		onData.destroy();
		onSend.destroy();
	}

}