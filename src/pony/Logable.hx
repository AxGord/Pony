package pony;

import haxe.PosInfos;
import pony.events.Signal2;
import pony.ILogable;
import pony.magic.HasSignal;

/**
 * Logable
 * @author AxGord <axgord@gmail.com>
 */
class Logable implements ILogable implements HasSignal {

	public function new() {}
	
	@:lazy public var onLog:Signal2<String, PosInfos>;
	@:lazy public var onError:Signal2<String, PosInfos>;
	
	public inline function error(s:String, ?p:PosInfos):Void eError.dispatch(s, p);
	public inline function log(s:String, ?p:PosInfos):Void eLog.dispatch(s, p);

}