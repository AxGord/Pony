package remote.client.actions;

import pony.Logable;

/**
 * RemoteAction
 * @author AxGord <axgord@gmail.com>
 */
class RemoteAction extends Logable implements pony.magic.HasAbstract {

	private var protocol:RemoteProtocol;
	public var onEnd:Void -> Void;

	public function new(protocol:RemoteProtocol, data:String) {
		super();
		this.protocol = protocol;
		run(data);
	}

	@:abstract private function run(data:String):Void {
		log(Type.getClassName(Type.getClass(this)) + ': ' + data);
	}

	public function end():Void {
		onEnd();
		destroy();
	}

	public function destroy():Void {
		destroySignals();
	}

}