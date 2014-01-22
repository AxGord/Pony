package pony.time;

import pony.events.*;

/**
 * ITimer
 * @author AxGord <axgord@gmail.com>
 */
interface ITimer < T:ITimer<T> > {
	
	var update:Signal1<T, Time>;
	var progress:Signal1<T, Float>;
	var complite:Signal1<T, DT>;
	
	var time:TimeInterval;
	var currentTime:Time;
	var repeatCount:Int;
	
	function start(?dt:DT):T;
	function stop():T;
	function reset():T;
	function dispatchUpdate():T;
	function destroy():Void;
	
}