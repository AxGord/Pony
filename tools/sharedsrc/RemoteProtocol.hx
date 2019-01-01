import haxe.io.Bytes;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.net.rpc.RPC;
import pony.net.rpc.IRPC;
import pony.net.rpc.RPCLog;
import pony.net.rpc.RPCFileTransport;
import pony.net.rpc.RPCPing;

/**
 * RemoteProtocol
 * @author AxGord <axgord@gmail.com>
 */
class RemoteProtocol extends RPC<RemoteProtocol> implements IRPC {

	@:sub public var log:RPCLog;
	@:sub public var file:RPCFileTransport;
	@:sub public var ping:RPCPing;

	@:rpc public var onAuth:Signal1<String>;
	@:rpc public var onReady:Signal0;
	@:rpc public var onCommand:Signal1<String>;
	@:rpc public var onCommandComplete:Signal2<String, Int>;
	@:rpc public var onZipLog:Signal1<Bytes>;
	@:rpc public var onGetInitFile:Signal0;

	@:rpc public var onGetFile:Signal1<String>;

}