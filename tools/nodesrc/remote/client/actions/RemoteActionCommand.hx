package remote.client.actions;

/**
 * RemoteActionCommand
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class RemoteActionCommand extends RemoteAction {

	override private function run(data: String): Void {
		super.run(data);
		protocol.onCommandComplete < end;
		protocol.commandRemote(data);
	}

	override public function destroy(): Void {
		super.destroy();
		protocol.onCommandComplete >> end;
	}

}