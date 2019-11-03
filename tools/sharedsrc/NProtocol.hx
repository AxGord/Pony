import pony.net.rpc.*;
import pony.events.*;
import types.*;

/**
 * NProtocol
 * @author AxGord <axgord@gmail.com>
 */
class NProtocol extends RPC<NProtocol> implements IRPC {

	@:sub public var log: RPCLog;

	@:rpc public var onRemote: Signal1<RemoteConfig>;
	@:rpc public var onBmfont: Signal1<Array<BmfontConfig>>;
	@:rpc public var onImagemin: Signal1<Array<ImageminConfig>>;
	@:rpc public var onPoeditor: Signal1<Array<PoeditorConfig>>;
	@:rpc public var onFtp: Signal1<Array<FtpConfig>>;
	@:rpc public var onDownload: Signal1<Array<DownloadConfig>>;
	@:rpc public var onFinish: Signal0;

}