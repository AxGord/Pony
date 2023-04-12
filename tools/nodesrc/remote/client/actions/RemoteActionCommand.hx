package remote.client.actions;

/**
 * RemoteActionCommand
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class RemoteActionCommand extends RemoteAction {

	#if (haxe_ver < 4.2) override #end
	private function run(data: String): Void {
		logData(data);
		protocol.onCommandComplete < end;
		protocol.commandRemote(data);
	}

	override public function destroy(): Void {
		super.destroy();
		protocol.onCommandComplete >> end;
	}

}