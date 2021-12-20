package pony.ui;

import haxe.io.Bytes;

import hxbitmini.Serializable;
import hxbitmini.Serializer;

/**
 * Binary atlas
 * @author AxGord <axgord@gmail.com>
 */
class BinaryAtlas implements Serializable {

	@:s public var file: String;
	@:s public var width: Int;
	@:s public var contents: Map<String, Array<BinaryAtlasParams>>;

	public function new() contents = new Map<String, Array<BinaryAtlasParams>>();
	public inline function toBytes(): Bytes return new Serializer().serialize(this);
	public static inline function fromBytes(bytes: Bytes): BinaryAtlas return new Serializer().unserialize(bytes, BinaryAtlas);

}