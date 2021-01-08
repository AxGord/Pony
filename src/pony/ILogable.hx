package pony;

import haxe.PosInfos;
import pony.events.Signal2;
import pony.events.Event2;

/**
 * Logable interface
 * @author AxGord <axgord@gmail.com>
 */
interface ILogable {

	var onLog(get, never): Signal2<String, PosInfos>;
	var onError(get, never): Signal2<String, PosInfos>;
	function error(s: String, ?p: PosInfos): Void;
	function log(s: String, ?p: PosInfos): Void;

	private var eLog: Event2<String, PosInfos>;
	private var eError: Event2<String, PosInfos>;

}