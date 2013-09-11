package pony.net;
import com.dongxiguo.protobuf.binaryFormat.LimitableBytesInput;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.DeltaTime;
import pony.events.Signal;

/**
 * Protobuf+SocketClient
 * @author AxGord <axgord@gmail.com>
 */
class Protobuf<A, B> {

	public var socket(default, set):SocketClient;
	public var data(default, null):Signal;
	public var onSend(default, null):Signal;
	private var fs:List < A->Void > ;
	
	private var a:Class<A>;
	private var b:Class<B>;
	private var awrite:A->BytesOutput->Void;
	private var bmerge:B->LimitableBytesInput->Void;
	
	public function new(a:Class<A>, b:Class<B>, awrite:A->BytesOutput->Void, bmerge:B->LimitableBytesInput->Void) {
		data = new Signal(this);
		onSend = new Signal(this);
		this.a = a;
		this.b = b;
		this.awrite = awrite;
		this.bmerge = bmerge;
		DeltaTime.update.add(trySend);
	}
	
	private function set_socket(s:SocketClient):SocketClient {
		if (socket != null) socket.data.remove(socketData);
		if (s != null) s.data.add(socketData);
		return socket = s;
	}
	
	public function send(f:A->Void):Void {
		if (fs == null) fs = new List < A->Void > ();
		fs.push(f);
	}
	
	private function trySend():Void {
		if (fs == null) return;
		if (socket == null || socket.closed) return;
		var builder:A = Type.createInstance(a, []);
		onSend.dispatch(builder);
		for (f in fs) f(builder);
		var output = new BytesOutput();
		awrite(builder, output);
		//builder.writeTo(b);
		socket.send(output);
		fs = null;
	}
	
	private function socketData(input:BytesInput):Void {
		var builder:B = Type.createInstance(b, []);
		//builder.mergeFrom(new LimitableBytesInput(input.readAll()));
		bmerge(builder, new LimitableBytesInput(input.readAll()));
		data.dispatch(builder);
	}
	
}