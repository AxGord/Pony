package pony.net;

import haxe.io.BytesOutput;

/**
 * SocketServer
 * @author AxGord <axgord@gmail.com>
 */
#if (!js||nodejs)
class SocketServer
#if nodejs
extends pony.net.nodejs.SocketServer
#elseif cs
extends pony.net.cs.SocketServer
#elseif neko
extends pony.net.neko.SocketServer
#else
extends pony.net.SocketServerBase
#end
#if !flash
implements ISocketServer
#end
{
	#if !flash
	public function new(port:Int, isWithLength:Bool = true, maxSize:Int = 1024) {
		super(port);
		this.isWithLength = isWithLength;
		this.maxSize = maxSize;
	}
	#end
	public inline function sendString(data:String):Void {
		var bo = new BytesOutput();
		bo.writeString(data);
		send(bo);
	}
	
	override public function destroy():Void {
		if (opened) super.destroy();
		else if (onOpen != null) onOpen << destroy;
	}
	
}
#end