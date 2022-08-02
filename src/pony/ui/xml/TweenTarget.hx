package pony.ui.xml;

import pony.geom.Point;

typedef TweenTarget<T> = {
	target: T,
	startPos: Point<Float>,
	endPos: Point<Float>
}