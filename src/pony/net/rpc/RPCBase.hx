package pony.net.rpc;

import haxe.io.Bytes;

/**
 * RPCBase
 * @author AxGord <axgord@gmail.com>
 */
class RPCBase<T:pony.net.rpc.IRPC> {

	private var serializer:hxbit.Serializer = new hxbit.Serializer();
	private var object(get, never):T;

	public function new() {}

	@:extern private inline function get_object():T return cast this;

	private function dataHandler(b:haxe.io.BytesInput):Void {
		serializer.refs = new Map();
		untyped serializer.knownStructs = [];
		serializer.setInput(b.readAll(), 0);
		object.__uid = untyped serializer.getObjRef();
		object.unserializeInit();
		object.unserialize(serializer);
		object.checkRemoteCalls();
	}

	@:extern private inline function pack():Bytes return serializer.serialize(object);

}