package remote.client.actions;

/**
 * RemoteActionSend
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class RemoteActionSend extends RemoteAction {

	#if (haxe_ver < 4.2) override #end
	private function run(data: String): Void {
		logData(data);
		protocol.file.stream.onComplete < end;
		protocol.file.stream.onGetData << streamDataHandler;
		protocol.file.stream.onCancel << streamErrorHandler;
		protocol.file.sendFile(data);
	}

	private function streamErrorHandler(): Void error('File stream error');
	private function streamDataHandler(): Void Sys.print('.');

	override public function destroy(): Void {
		super.destroy();
		protocol.file.stream.onComplete >> end;
		protocol.file.stream.onGetData >> streamDataHandler;
		protocol.file.stream.onCancel >> streamErrorHandler;
	}

}