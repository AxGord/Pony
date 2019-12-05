package pony.geom;

/**
 * Direction
 * @author AxGord <axgord@gmail.com>
 */
@:enum abstract Direction(Int) from Int to Int {
	var Left = 0;
	var Right = 1;
	var Up = 2;
	var Down = 3;
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