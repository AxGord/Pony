package pony.net;

#if !dox
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Timer;
import pony.Logable;
#end
import pony.events.*;
import pony.magic.HasSignal;

/**
 * SocketClientBase
 * @author AxGord <axgord@gmail.com>
 */
class SocketClientBase extends Logable implements HasSignal {

	public var readLengthSize:UInt;
	
	#if (!js||nodejs)
	public var server(default, null):SocketServer;
	#end
	
	@:auto public var onData:Signal2<BytesInput, SocketClient>;
	@:auto public var onString:Signal2<String, SocketClient>;
	@:auto public var onClose:Signal0;
	@:auto public var onDisconnect:Signal1<SocketClient>;
	@:lazy public var onLostConnection:Signal0;
	@:lazy public var onReconnect:Signal0;
	@:lazy public var onOpen:Signal0;
	@:lazy public var onConnect:Signal1<SocketClient>;
	
	public var opened(default,null):Bool;
	
	public var id(default,null):Int;
	public var host(default,null):String;
	public var port(default, null):Int;
	public var isWithLength:Bool;
	public var tryCount:Int;
	
	private var reconnectDelay:Int = -1;
	private var maxSize:UInt;
	
	//For big data
	private var waitNext:UInt;
	private var waitBuf:BytesOutput = new BytesOutput();

	private var tryCounter:Int = 0;
	
	public function new(?host:String, port:Int, reconnect:Int = -1, tryCount:Int = 0, aIsWithLength:Bool = true, maxSize:Int = 1024) 
	{
		super();
		if (host == null) host = '127.0.0.1';
		this.host = host;
		this.port = port;
		this.reconnectDelay = reconnect;
		this.tryCount = tryCount;
		this.maxSize = maxSize;
		isWithLength = aIsWithLength;
		sharedInit();
		_open();
	}
	
	private function readString(b:BytesInput):Bool {
		eString.dispatch(b.readString(b.length), cast this);
		return true;
	}
	
	private function sharedInit():Void {
		readLengthSize = 4;
		opened = false;
		id = -1;
		eString.onTake << function() onData.add(readString, -1);
		eString.onLost << function() onData.remove(readString);
	}
	
	private function tryAgain():Void {
		close();
		if (reconnectDelay == 0) {
			log('Reconnect');
			_open();
		}
		#if ((!dox && HUGS) || nodejs || flash)
		else if (reconnectDelay > 0) {
			log('Reconnect after ' + reconnectDelay + ' ms');
			Timer.delay(_open, reconnectDelay);
		}
		#end
	}
	
	public function reconnect():Void {
		close();
		open();
	}
	
	private function badConnection():Bool {
		onError >> badConnection;
		onDisconnect >> badConnection;
		log('Bad connection');
		if (opened) eLostConnection.dispatch();
		tryAgain();
		return true;
	}
	
	private function reconnectHandler():Void {
		tryCounter = 0;
		eReconnect.dispatch();
	}
	
	private function close():Void {
		if (!opened) return;
		opened = false;
		eDisconnect.dispatch(cast this);
		eClose.dispatch();
	}
	
	private function connect():Void {
		opened = true;
		eConnect.dispatch(cast this);
		eOpen.dispatch();
	}
	
	private function _open():Void {
		if (tryCounter < tryCount) {
			tryCounter++;
			onError.once(badConnection, -100);
			onDisconnect.once(badConnection, -100);
		}
		open();
	}
	
	private function open():Void {
		onError < tryAgain;
	}
	
	#if (!js||nodejs)
	@:access(pony.net.SocketServer)
	public function init(server:SocketServer, id:Int):Void {
		
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
	
	inline public function send2other(data:BytesOutput):Void server.send2other(data, cast this);
	#end
	
	dynamic public function readLength(bi:BytesInput):UInt return bi.readInt32();
	
	private function joinData(bi:BytesInput):Void {
		if (isWithLength)
		{
			var size:UInt = 0;
			var len:UInt = 0;
			
			if (waitNext > 0) {
				size = waitNext;
				len = bi.length;
			} else {
				if (bi.length < 4) return;//ignore small data
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
			
		}
		else
		{
			eData.dispatch(bi, cast this);
		}
	}
	
	public function destroy():Void
	{
		close();
		eLostConnection.destroy();
		eLostConnection = null;
		eReconnect.destroy();
		eReconnect = null;
		eString.destroy();
		eString = null;
		eData.destroy();
		eData = null;
		eConnect.destroy();
		eConnect = null;
		eOpen.destroy();
		eOpen = null;
		eClose.destroy();
		eClose = null;
		eDisconnect.destroy();
		eDisconnect = null;
	}
	
}