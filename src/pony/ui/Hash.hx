package pony.ui;

import haxe.io.Bytes;

import hxbitmini.Serializable;
import hxbitmini.Serializer;

/**
 * Hash
 * @author AxGord <axgord@gmail.com>
 */
@:keep class Hash implements Serializable {

	@:s public var units: Map<String, Bytes>;
	public function new(units: Map<String, Bytes>) this.units = units;
	public inline function toBytes(): Bytes return new Serializer().serialize(this);
	public static inline function fromBytes(bytes: Bytes): Hash return new Serializer().unserialize(bytes, Hash);

}