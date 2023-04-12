package remote.client.actions;

import pony.Logable;
import pony.magic.HasAbstract;

/**
 * RemoteAction
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
#if (haxe_ver >= 4.2) abstract #end
class RemoteAction extends Logable implements HasAbstract {

	private var protocol: RemoteProtocol;

	public function new(protocol: RemoteProtocol, data: String) {
		super();
		this.protocol = protocol;
		run(data);
	}

	public dynamic function onEnd(): Void {}

	@:abstract private function run(data: String): Void;

	public function end(): Void {
		onEnd();
		destroy();
	}

	private inline function logData(data: String): Void {
		log(Type.getClassName(@:nullSafety(Off) Type.getClass(this)) + ': ' + data);
	}

}