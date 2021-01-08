package pony.net;

import haxe.io.Bytes;
#if !dox
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Timer;
import pony.Logable;
#end
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.events.Event0;
import pony.events.Event1;
import pony.events.Event2;
import pony.magic.HasSignal;

/**
 * SocketClientBase
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class SocketClientBase extends Logable implements HasSignal {

	public static inline var MIN_DATA_SIZE: Int = 4;

	public var readLengthSize: UInt = 0;

	#if (!js || nodejs)
	public var server(default, null): Null<SocketServer>;
	#end

	@:auto public var onData: Signal2<BytesInput, SocketClient>;
	@:auto public var onString: Signal2<String, SocketClient>;
	@:auto public var onClose: Signal0;
	@:auto public var onDisconnect: Signal1<SocketClient>;
	@:lazy public var onLostConnection: Signal0;
	@:lazy public var onReconnect: Signal0;
	@:lazy public var onOpen: Signal0;
	@:lazy public var onConnect: Signal1<SocketClient>;

	public var opened(default, null): Bool = false;

	public var id(default, null): Int = -1;
	public var host(default, null): String;
	public var port(default, null): Int;
	public var isWithLength: Bool;
	public var tryCount: Int;

	private var reconnectDelay: Int = -1;
	private var maxSize: UInt;

	// For big data
	private var waitNext: UInt = 0;
	private var waitBuf: BytesOutput = new BytesOutput();

	private var tryCounter: Int = 0;

	public function new(?host: String, port: Int, reconnect: Int = -1, tryCount: Int = 0, isWithLength: Bool = true, maxSize: Int = 1024) {
		super();
		if (host == null) host = '127.0.0.1';
		this.host = host;
		this.port = port;
		this.reconnectDelay = reconnect;
		this.tryCount = tryCount;
		this.maxSize = maxSize;
		this.isWithLength = isWithLength;
		sharedInit();
		reopen();
	}

	private function readString(b: BytesInput): Bool {
		eString.dispatch(b.readString(b.length), cast this);
		return true;
	}

	private function sharedInit(): Void {
		readLengthSize = 4;
		opened = false;
		id = -1;
		eString.onTake << function() onData.add(readString, -1);
		eString.onLost << function() onData.remove(readString);
	}

	public function tryAgain(): Void {
		close();
		if (reconnectDelay == 0) {
			log('Reconnect');
			reopen();
		}
		#if ((!dox && HUGS) || nodejs || flash)
		else if (reconnectDelay > 0) {
			log('Reconnect after ' + reconnectDelay + ' ms');
			Timer.delay(reopen, reconnectDelay);
		}
		#end
	}

	public function reconnect(): Void {
		close();
		open();
	}

	private function badConnection(): Bool {
		onError >> badConnection;
		onDisconnect >> badConnection;
		log('Bad connection');
		if (opened) eLostConnection.dispatch();
		tryAgain();
		return true;
	}

	private function reconnectHandler(): Void {
		tryCounter = 0;
		eReconnect.dispatch();
	}

	private function close(): Void {
		if (!opened) return;
		log('Disconnect');
		opened = false;
		eDisconnect.dispatch(cast this);
		eClose.dispatch();
	}

	private function connect(): Void {
		log('Connect');
		opened = true;
		eConnect.dispatch(cast this);
		eOpen.dispatch();
	}

	private function reopen(): Void {
		if (tryCounter < tryCount) {
			tryCounter++;
			onError.once(badConnection, -100);
			onDisconnect.once(badConnection, -100);
		}
		open();
	}

	private function open(): Void {
		onError < tryAgain;
	}

	#if (!js || nodejs)

	@:access(pony.net.SocketServer)
	public function init(server: SocketServer, id: Int): Void {
		eData = new Event2<BytesInput, SocketClient>();
		eString = new Event2<String, SocketClient>();
		eClose = new Event0();
		eDisconnect = new Event1<SocketClient>();
		eLostConnection = new Event0();
		eReconnect = new Event0();
		eOpen = new Event0();
		eConnect = new Event1<SocketClient>();

		onData << server.eData;
		onDisconnect << server.eDisconnect;
		onConnect << server.eConnect;

		sharedInit();
		this.server = server;
		this.maxSize = server.maxSize;
		this.isWithLength = server.isWithLength;
		this.id = id;

		waitNext = 0;
		waitBuf = new BytesOutput();

		if (!server.eString.empty) onString << server.eString;
	}

	public inline function send2other(data: BytesOutput): Void if (server != null) server.send2other(data, cast this);

	#end

	public dynamic function readLength(bi: BytesInput): UInt return bi.readInt32();

	private function joinData(bi: BytesInput): Void {
		if (isWithLength) {
			var size: UInt = 0;
			var len: UInt = 0;

			if (waitNext > 0) {
				size = waitNext;
				len = bi.length;
			} else {
				if (bi.length < MIN_DATA_SIZE) return; // ignore small data
				size = readLength(bi);
				len = bi.length - readLengthSize;
			}

			if (size > len) {
				waitNext = size - len;
				waitBuf.write(bi.read(len));
			} else {
				if (waitNext > 0) {
					waitNext = 0;
					waitBuf.write(bi.read(size));
					eData.dispatch(new BytesInput(waitBuf.getBytes()), cast this);
				} else {
					eData.dispatch(new BytesInput(bi.read(size)), cast this);
				}
				waitBuf = new BytesOutput();
			}

		} else {
			eData.dispatch(bi, cast this);
		}
	}

	public function destroy(): Void {
		close();
		eLostConnection.destroy();
		@:nullSafety(Off) eLostConnection = null;
		eReconnect.destroy();
		@:nullSafety(Off) eReconnect = null;
		eString.destroy();
		@:nullSafety(Off) eString = null;
		eData.destroy();
		@:nullSafety(Off) eData = null;
		eConnect.destroy();
		@:nullSafety(Off) eConnect = null;
		eOpen.destroy();
		@:nullSafety(Off) eOpen = null;
		eClose.destroy();
		@:nullSafety(Off) eClose = null;
		eDisconnect.destroy();
		@:nullSafety(Off) eDisconnect = null;
	}

	private inline function logBytes(msg: String, b: Bytes): Void {
		logf(function(): String {
			var r: String = '';
			var i: Int = 0;
			for (s in b.toHex().toUpperCase().split('')) {
				if (++i != 1) {
					if (i % (4 * 16) == 1) r += '\n';
					else if (i % (4 * 4) == 1) r += '  ';
					else if (i % 4 == 1) r += ' ';
				}
				r += s;
			}
			return '$msg (${b.length})\n$r\n';
		});
	}

	public inline function enableLogInputData(): Void onData.add(logInputDataHandler, -1000);
	public inline function disableLogInputData(): Void onData >> logInputDataHandler;

	private function logInputDataHandler(bi: BytesInput): Void {
		logBytes('Get data', bi.readAll());
		bi.position = 0;
	}

}