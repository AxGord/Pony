import types.RemoteConfig;
import js.Node;
import js.Error;
import module.NModule;
import types.ImageminConfig;
import types.PoeditorConfig;
import types.FtpConfig;
import types.UglifyConfig;
import types.DownloadConfig;
import types.BmfontConfig;
import types.ServerConfig;
import pony.net.SocketClient;
import pony.NPM;
import pony.Logable;

/**
 * NMain
 * @author AxGord <axgord@gmail.com>
 */
class NMain extends Logable {

	private var client: SocketClient;
	private var rpc: NProtocol;

	private function new() {
		super();
		var port: Null<Int> = Std.parseInt(Sys.args()[0]);
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
		rpc.onServer << serverHandler;
		rpc.onUglify << uglifyHandler;
		rpc.onDownload << downloadHandler;
		rpc.onRemote << remoteHandler;
	}

	private function errorHandler(err: Error):Void error(err.stack);

	private function bmfontHandler(cfg: Array<BmfontConfig>): Void {
		listen(cast new module.Bmfont(cfg));
	}

	private function imageminHandler(cfg: Array<ImageminConfig>): Void {
		listen(cast new module.Imagemin(cfg));
	}

	private function poeditorHandler(cfg: Array<PoeditorConfig>): Void {
		listen(cast new module.Poeditor(cfg));
	}

	private function ftpHandler(cfg: Array<FtpConfig>): Void {
		listen(cast new module.Ftp(cfg));
	}

	private function serverHandler(cfg: Array<ServerConfig>): Void {
		listen(cast new module.server.Server(cfg));
	}

	private function uglifyHandler(cfg: Array<UglifyConfig>): Void {
		listen(cast new module.Uglify(cfg));
	}

	private function downloadHandler(cfg: Array<DownloadConfig>): Void {
		listen(cast new module.Download(cfg));
	}

	private function remoteHandler(cfg: Array<RemoteConfig>): Void {
		listen(cast new module.Remote(cfg));
	}

	private function listen(m: NModule<Any>): Void {
		m.onLog << log;
		m.onError << error;
		m.onFinish < rpc.finishRemote;
		m.start();
	}

	private static function main(): Void new NMain();

}