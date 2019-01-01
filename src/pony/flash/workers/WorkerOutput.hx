package pony.flash.workers;

import flash.events.Event;
import pony.magic.Declarator;
import pony.Tools;

/**
 * WorkerOutput
 * @author AxGord <axgord@gmail.com>
 */
class WorkerOutput<T1, T2> implements Declarator {
	
	@:arg public var name(default,null):String;
	@:arg private var gate:IWorkerGatePool;
	
	private var q:Queue < T1->(T2->Void)->Void > = new Queue < T1->(T2->Void)->Void > (_request);

	public function new() {
		q.busy = true;
		req = gate._registerOutput(name, response, q.next);
	}
	
	inline public function request(r:T1, ?cb:T2->Void):Void q.call(r, cb);
	
	private function _request(r:T1, cb:T2->Void):Void {
		_response = cb != null ? cb: Tools.nullFunction1;
		req(r);
	}
	
	dynamic private function req(r:T1):Void {}
	
	private function response(r:T2):Void {
		_response(r);
		q.next();
	}
	
	dynamic private function _response(r:T2):Void { }
	
	public function destroy():Void {
		gate = null;
		q = null;
		req = null;
		_response = null;
	}
	
}