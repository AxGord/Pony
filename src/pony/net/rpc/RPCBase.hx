package pony.net.rpc;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import hxbitmini.Serializer;

/**
 * RPCBase
 * @author AxGord <axgord@gmail.com>
 */
class RPCBase<T: pony.net.rpc.IRPC> {

	private var serializer: Serializer = new Serializer();
	private var object(get, never): T;

	public function new() {}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_object(): T return cast this;

	private function dataHandler(b: BytesInput):Void {
		serializer.setInput(b.readAll(), 0);
		var clidx: Int = object.getCLID();
		if (@:privateAccess serializer.convert != null && @:privateAccess serializer.convert[clidx] != null ) {
			var conv = @:privateAccess serializer.convert[clidx];
			if ( conv.hadCID ) {
				var realIdx = serializer.getCLID();
				if ( conv.hasCID ) {
					var c = @:privateAccess cast Serializer.CL_BYID[realIdx];
					clidx = (c: Dynamic).__clid;
				}
			}
		} else {
			if (@:privateAccess Serializer.CLIDS[clidx] != 0 ) {
				var realIdx = serializer.getCLID();
				var c = @:privateAccess cast Serializer.CL_BYID[realIdx];
				if ( @:privateAccess serializer.convert != null ) clidx = (c: Dynamic).__clid; // real class convert
			}
		}
		object.unserializeInit();
		if (@:privateAccess serializer.convert != null && @:privateAccess serializer.convert[clidx] != null )
			@:privateAccess serializer.convertRef(object, @:privateAccess serializer.convert[clidx]);
		else
			object.unserialize(serializer);
		object.checkRemoteCalls();
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function pack(): Bytes return serializer.serialize(object);

}