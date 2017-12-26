package pony.net.rpc;

import haxe.PosInfos;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;

/**
 * RPCLogable
 * @author AxGord <axgord@gmail.com>
 */
@:final class RPCLogable
extends pony.net.rpc.RPCUnit<RPCLogable>
#if !macro implements pony.ILogable #end
implements pony.magic.HasSignal
implements pony.net.rpc.IRPC {

	@:rpc public var onLog:Signal2<String, PosInfos>;
	@:rpc public var onError:Signal2<String, PosInfos>;

	#if !macro
	public inline function error(s:String, ?p:PosInfos):Void eError.dispatch(s, p);
	public inline function log(s:String, ?p:PosInfos):Void eLog.dispatch(s, p);
	#end

}