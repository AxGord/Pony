package remote.client;

import pony.Logable;
import types.RemoteConfig;
import remote.client.actions.RemoteAction;
import remote.client.actions.RemoteActionGet;
import remote.client.actions.RemoteActionSend;
import remote.client.actions.RemoteActionExec;
import remote.client.actions.RemoteActionCommand;

/**
 * RemoteActionRunner
 * @author AxGord <axgord@gmail.com>
 */
class RemoteActionRunner extends Logable {

	public var onEnd:Void -> Void;
	private var protocol:RemoteProtocol;
	private var commands:Array<RemoteCommand>;

	public function new(protocol:RemoteProtocol, commands:Array<RemoteCommand>) {
		super();
		this.protocol = protocol;
		this.commands = commands;
	}

	public function run():Void runNext();

	private function runNext():Void {
		if (commands.length > 0) {
			switch commands.shift() {
				case Get(file): listen(new RemoteActionGet(protocol, file));
				case Send(file): listen(new RemoteActionSend(protocol, file));
				case Exec(command): listen(new RemoteActionExec(protocol, command));
				case Command(command): listen(new RemoteActionCommand(protocol, command));
			}
		} else {
			onEnd();
		}
	}

	private function listen(action:RemoteAction):Void {
		action.onLog << log;
		action.onError << error;
		action.onEnd = runNext;
	}

}