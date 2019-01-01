package remote.client;

/**
 * RemoteClientCreate
 * @author AxGord <axgord@gmail.com>
 */
class RemoteClientCreate {

	public var runned(default, null):Bool = false;

	private var protocol:RemoteProtocol;

	public function new(args:Array<String>) {
		if (args[0] == 'create') {
			var urla = args[1].split('@');
			var key:String = null;
			var url:Array<String> = null;
			if (urla.length > 1) {
				key = urla[0];
				url = urla[1].split(':');
			} else {
				url = urla[0].split(':');
			}
			var host:String = url[0];
			var port:Int = url.length > 1 ? Std.parseInt(url[1]) : null;
			protocol = RemoteClientMain.createProtocol(host, port, key);
			protocol.log.onLog << remoteLogHandler;
			protocol.onReady < protocolReadyHandler;
			runned = true;
		}
	}

	private function protocolReadyHandler():Void {
		protocol.file.enable();
		protocol.file.stream.onStreamData << streamDataHandler;
		protocol.file.stream.onStreamEnd << protocol.socket.destroy;
		protocol.file.stream.onError << error;
		protocol.getInitFileRemote();
	}

	private function error():Void {
		Sys.println('Error');
		Sys.exit(3);
	}

	private function streamDataHandler():Void Sys.print('.');

	private function remoteLogHandler(s:String):Void {
		for (e in s.split('\n')) if (e != null) Sys.println('| $e');
	}

}