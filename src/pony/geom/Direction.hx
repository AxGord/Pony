package pony.geom;

/**
 * Direction
 * @author AxGord <axgord@gmail.com>
 */
@:enum abstract Direction(UInt) from UInt to UInt {

	var Undefined = 0x0000;
	var Left = 0x0001;
	var Right = 0x0010;
	var Up = 0x0100;
	var Down = 0x1000;

	@:to(String) public function toString(): String {
		return switch this {
			case Undefined: 'Undefined';
			case Left: 'Left';
			case Right: 'Right';
			case Up: 'Up';
			case Down: 'Down';
			case _: throw 'Error';
		}
	}

}

/**
 * Directions
 * @author AxGord <axgord@gmail.com>
 */
abstract Directions(UInt) from UInt to UInt {

	@:to(String) public static function toString(v: UInt): String {
		var r: Array<String> = [];
		if (v & Up != 0) r.push(Up);
		if (v & Down != 0) r.push(Down);
		if (v & Left != 0) r.push(Left);
		if (v & Right != 0) r.push(Right);
		return r.join(' | ');
	}

}


/**
 * DirectionContainer
 * @author AxGord <axgord@gmail.com>
 */
typedef DirectionContainer<T> = {
	left: T,
	right: T,
	up: T,
	down: T
}