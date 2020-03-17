package remote.client.actions;

import pony.sys.Process;

/**
 * RemoteActionExec
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class RemoteActionExec extends RemoteAction {

	@:nullSafety(Off) private var process: Process;

	override private function run(data: String): Void {
		super.run(data);
		process = new Process(data);
		process.onComplete < end;
		process.onError < error;
		process.onLog << log;
		process.run();
	}

	override public function destroy(): Void {
		super.destroy();
		process.destroy();
		@:nullSafety(Off) process = null;
	}

}