package pony.net.rpc;

import haxe.PosInfos;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;

/**
 * RPCLog
 * @author AxGord <axgord@gmail.com>
 */
@:final class RPCLog
extends pony.net.rpc.RPCUnit<RPCLog>
#if !macro implements pony.ILogable #end
implements pony.net.rpc.IRPC {

	@:rpc public var onLog:Signal2<String, PosInfos>;
	@:rpc public var onError:Signal2<String, PosInfos>;

	#if !macro
	public inline function error(s:String, ?p:PosInfos):Void errorRemote(s, p);
	public inline function log(s:String, ?p:PosInfos):Void logRemote(s, p);
	#end

}