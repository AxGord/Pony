package pony.physics.nape;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.Byte;
import pony.geom.Point;
import pony.geom.Rect;
import nape.phys.Body;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.space.Space;
import nape.shape.Shape;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;

/**
 * BodyBody
 * @author AxGord <axgord@gmail.com>
 */
class BodyBody extends BodyBase {

	public function new(
		body:Body,
		anchor:Vec2,
		space:Space,
		?limits:Rect<Float>,
		isStatic:Bool = false,
		isBullet:Bool = false,
		?group:NapeGroup
	) {
		super(space, limits, isStatic, isBullet, body, anchor, group);
	}

	override function init():Void {}

}