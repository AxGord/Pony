package pony.net.rpc;

import haxe.io.Bytes;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;

/**
 * FileTransport
 * @author AxGord <axgord@gmail.com>
 */
@:final class RPCFileTransport extends pony.net.rpc.RPCUnit<FileTransport> implements pony.magic.HasSignal implements pony.net.rpc.IRPC {

	@:rpc public var onFileBegin:Signal1<String>;
	@:rpc public var onFileData:Signal1<Bytes>;
	@:rpc public var onFileDataReceived:Signal1<String>;
	@:rpc public var onFileEnd:Signal0;
	@:rpc public var onFileReceived:Signal2<String, String>;
	
}