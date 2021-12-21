package pony.ui;

import hxbitmini.Serializable;

/**
 * Binary atlas params
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:keep class BinaryAtlasParams implements Serializable {

	@:s public var x: UInt = 0;
	@:s public var y: UInt = 0;
	@:s public var w: UInt = 0;
	@:s public var h: UInt = 0;
	@:s public var dx: UInt = 0;
	@:s public var dy: UInt = 0;
	@:s public var origW: UInt = 0;
	@:s public var origH: UInt = 0;

	public function new() {}

}