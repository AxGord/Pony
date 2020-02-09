package pony.flash.workers;

/**
 * @author AxGord <axgord@gmail.com>
 */
interface IWorkerGatePool {

	function _registerOutput<T1, T2>(name: String, response: T2->Void, unlock: Void->Void): T1->Void;
	function _registerInput<T1, T2>(name: String, request: T1->Void): T2->Void;

}