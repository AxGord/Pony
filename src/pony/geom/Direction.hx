package pony.geom;

/**
 * Direction
 * @author AxGord <axgord@gmail.com>
 */
@:enum abstract Direction(Int) from Int to Int {
	var Undefined = 0;
	var Left = 1;
	var Right = 2;
	var Up = 3;
	var Down = 4;
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