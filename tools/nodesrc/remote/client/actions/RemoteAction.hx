package remote.client.actions;

import pony.Logable;
import pony.magic.HasAbstract;

/**
 * RemoteAction
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class RemoteAction extends Logable implements HasAbstract {

	private var protocol: RemoteProtocol;

	public function new(protocol: RemoteProtocol, data: String) {
		super();
		this.protocol = protocol;
		run(data);
	}

	public dynamic function onEnd(): Void {}

	@:abstract private function run(data: String): Void {
		log(Type.getClassName(Type.getClass(this)) + ': ' + data);
	}

	public function end(): Void {
		onEnd();
		destroy();
	}

}