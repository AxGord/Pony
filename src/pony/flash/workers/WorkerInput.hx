package pony.flash.workers;

import pony.magic.Declarator;

/**
 * WorkerInput
 * @author AxGord <axgord@gmail.com>
 */
class WorkerInput<T1, T2> implements Declarator {

	@:arg public var name(default, null): String;

	@:arg private var gate: IWorkerGatePool;

	public function new() {
		result = gate._registerInput(name, _request);
	}

	private function _request(r: T1): Void
		request(r);

	public dynamic function request(r: T1): Void {}

	public dynamic function result(r: T2): Void {}

	public function destroy(): Void {
		gate = null;
		request = Tools.nullFunction1;
		result = null;
	}

}