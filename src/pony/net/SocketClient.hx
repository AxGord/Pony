package pony.net;

import haxe.Int64;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.events.Signal1;
import pony.events.Signal2;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
#if (!js || nodejs)
class SocketClient
	#if nodejs extends pony.net.nodejs.SocketClient
	#elseif cs extends pony.net.cs.SocketClient
	#elseif flash extends pony.net.flash.SocketClient
	#elseif openfl extends pony.net.openfl.SocketClient
	#elseif neko extends pony.net.neko.SocketClient
#end implements ISocketClient {

	private static inline var DEFAULT_LEN_BLOCK_SIZE: Int = 4;

	@:auto public var onTask: Signal2<BytesInput, SocketClient>;
	@:auto public var onTaskError: Signal1<SocketClient>;

	public var writeLengthSize: UInt;

	private var stack: Array<BytesOutput>;
	private var taskPrefix: BytesInput;
	private var taskDataLength: Int64 = -1;
	private var taskBuffer: BytesOutput;

	override function sharedInit(): Void {
		writeLengthSize = DEFAULT_LEN_BLOCK_SIZE;
		stack = [];
		super.sharedInit();
	}

	#if !cs // Not working for CS
	public dynamic function writeLength(bo: BytesOutput, length: UInt): Void bo.writeInt32(length);
	#end

	override public function send(data: BytesOutput): Void {
		if (!opened) {
			stack.push(data);
			return;
		}
		var len: UInt = data.length;
		var needSplit: Bool = maxSize != 0 && len > maxSize;
		if (isWithLength || needSplit) {
			var bo: BytesOutput = new BytesOutput();
			#if cs
			if (isWithLength) bo.writeInt32(len);
			#else
			if (isWithLength) writeLength(bo, len);
			#end
			if (needSplit) {
				if (isWithLength && maxSize > SocketClientBase.MIN_DATA_SIZE + writeLengthSize) maxSize -= writeLengthSize;
				var b: BytesInput = new BytesInput(data.getBytes());
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

	public function sendBytes(b: Bytes): Void {
		var bo: BytesOutput = new BytesOutput();
		bo.write(b);
		send(bo);
	}

	public function sendString(data: String): Void {
		var bo: BytesOutput = new BytesOutput();
		bo.writeString(data);
		send(bo);
	}

	public function sendStack(): Void if (stack.length > 0) send(stack.shift());
	public function sendAllStack(): Void while (stack.length > 0) send(stack.shift());

	public inline function setTaskb(prefix: Bytes, ?len: Int64): Signal2<BytesInput, SocketClient> {
		var bo: BytesOutput = new BytesOutput();
		bo.write(prefix);
		return setTask(bo, len);
	}

	public inline function setTask(?prefix: BytesOutput, ?len: Int64): Signal2<BytesInput, SocketClient> {
		taskBuffer = new BytesOutput();
		taskPrefix = prefix == null ? null : new BytesInput(prefix.getBytes());
		taskDataLength = len == null ? 0 : len;
		onData << taskDataHandler;
		return onTask;
	}

	public inline function removeTask(): Void {
		taskBuffer = null;
		taskPrefix = null;
		taskDataLength = -1;
		onData >> taskDataHandler;
	}

	private function taskDataHandler(bi: BytesInput): Void {
		if (taskDataLength == -1) return;
		if (taskPrefix != null) {
			if (bi.length < taskPrefix.length - taskPrefix.position) {
				if (taskPrefix.read(bi.length).compare(bi.readAll()) != 0) taskError();
				return;
			} else if (bi.read(taskPrefix.length - taskPrefix.position).compare(taskPrefix.readAll()) != 0) {
				taskError();
				return;
			} else {
				taskPrefix = null;
			}
		}
		if (taskDataLength == 0) {
			var b: BytesInput = new BytesInput(bi.readAll());
			removeTask();
			eTask.dispatch(null, this);
			taskDataHandler(b);
		} else {
			taskBuffer.write(bi.readAll());
			if (taskBuffer.length >= taskDataLength) {
				var b: BytesInput = new BytesInput(taskBuffer.getBytes());
				var r: BytesInput = new BytesInput(b.read(taskDataLength.low)); // todo high
				removeTask();
				eTask.dispatch(r, this);
				taskDataHandler(new BytesInput(b.readAll()));
			}
		}
	}

	private inline function taskError(): Void {
		removeTask();
		eTaskError.dispatch(this);
	}

	public function sendSetTask(out: Bytes, ?prefix: Bytes, len: UInt = 0): Signal2<BytesInput, SocketClient> {
		var ob: BytesOutput = new BytesOutput();
		ob.write(out);
		send(ob);
		if (prefix != null) {
			var pb: BytesOutput = new BytesOutput();
			pb.write(prefix);
			return setTask(pb, len);
		} else {
			return setTask(len);
		}
	}

	public inline function sendSetTaskSym(b: Bytes, len: UInt = 0): Signal2<BytesInput, SocketClient> {
		return sendSetTask(b, b, len);
	}

}
#else
typedef SocketClient = SocketClientBase;
#end