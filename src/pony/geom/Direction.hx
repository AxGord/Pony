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