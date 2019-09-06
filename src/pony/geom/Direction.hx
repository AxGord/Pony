package pony.geom;

/**
 * Direction
 * @author AxGord
 */
enum Direction { left; right; up; down; }

/**
 * DirectionContainer
 * @author AxGord
 */
typedef DirectionContainer<T> = {left:T, right:T, up:T, down:T }