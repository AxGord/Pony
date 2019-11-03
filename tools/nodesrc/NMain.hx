
import haxe.io.Output;
import haxe.io.Bytes;
import js.Node;
import hxbit.Serializer;
import haxe.Log;
import pony.Logable;
import pony.Tools;
import module.NModule;
import types.ImageminConfig;
import types.PoeditorConfig;
import types.FtpConfig;
import types.DownloadConfig;
import types.BmfontConfig;
import pony.net.rpc.RPC;
import pony.net.SocketServer;
import pony.net.SocketClient;
import pony.NPM;

/**
 * NMain
 * @author AxGord <axgord@gmail.com>
 */
class NMain extends Logable {

	private var client:SocketClient;
	private var rpc:NProtocol;

	private function new() {
		super();
		var port:Null<Int> = Std.parseInt(Sys.args()[0]);
		if (port == null) throw 'Port not set';
		NPM.capture_console.startCapture(Node.process.stdout, log);
		NPM.capture_console.startCapture(Node.process.stderr, log);
		
		client = new SocketClient(Utils.NPORT);
		Node.process.on('uncaughtException', errorHandler);
		client.onLog << eLog;
		client.onError << eError;
		rpc = new NProtocol(client);
		onLog << rpc.log.logRemote;
		onError << rpc.log.errorRemote;
		rpc.onBmfont << bmfontHandler;
		rpc.onImagemin << imageminHandler;
		rpc.onPoeditor << poeditorHandler;
		rpc.onFtp << ftpHandler;
		rpc.onDownload << downloadHandler;
	}

	private function errorHandler(err:js.Error):Void error(err.stack);

	private function bmfontHandler(cfg:Array<BmfontConfig>):Void {
		listen(cast new module.Bmfont(cfg));
	}

	private function imageminHandler(cfg:Array<ImageminConfig>):Void {
		listen(cast new module.Imagemin(cfg));
	}

	private function poeditorHandler(cfg:Array<PoeditorConfig>):Void {
		listen(cast new module.Poeditor(cfg));
	}

	private function ftpHandler(cfg:Array<FtpConfig>):Void {
		listen(cast new module.Ftp(cfg));
	}

	private function downloadHandler(cfg:Array<DownloadConfig>):Void {
		listen(cast new module.Download(cfg));
	}

	private function listen(m:NModule<Any>):Void {
		m.onLog << log;
		m.onError << error;
		m.onFinish < rpc.finishRemote;
		m.start();
	}

	private static function main():Void new NMain();

}