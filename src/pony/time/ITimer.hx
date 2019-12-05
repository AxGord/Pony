package pony.time;

import pony.events.Signal1;

/**
 * ITimer
 * @author AxGord <axgord@gmail.com>
 */
interface ITimer<T: ITimer<Dynamic>> {

	#if !flash
	var update(get, never): Signal1<Time>;
	var progress(get, never): Signal1<Float>;
	var complete(get, never): Signal1<DT>;
	#end
	var time: TimeInterval;
	var currentTime: Time;
	var repeatCount: Int;

	//Have cs problem now:
	//function start(?dt: DT): T;
	function stop(): T;
	function reset(): T;
	function dispatchUpdate(): T;
	function destroy(): Void;

}