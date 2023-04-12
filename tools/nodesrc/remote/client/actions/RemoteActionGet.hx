package remote.client.actions;

/**
 * RemoteActionGet
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class RemoteActionGet extends RemoteAction {

	#if (haxe_ver < 4.2) override #end
	private function run(data: String): Void {
		logData(data);
		protocol.file.enable();
		protocol.file.stream.onStreamEnd < end;
		protocol.file.stream.onStreamData << streamDataHandler;
		protocol.file.stream.onError << streamErrorHandler;
		protocol.getFileRemote(data);
	}

	private function streamErrorHandler(): Void error('File stream error');
	private function streamDataHandler(): Void Sys.print('.');

	override public function destroy(): Void {
		super.destroy();
		protocol.file.disable();
		protocol.file.stream.onStreamEnd >> end;
		protocol.file.stream.onStreamData >> streamDataHandler;
		protocol.file.stream.onError >> streamErrorHandler;
	}

}