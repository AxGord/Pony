package pony.physics.nape;

import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;
import pony.geom.Rect;

/**
 * BodyBody
 * @author AxGord <axgord@gmail.com>
 */
class BodyBody extends BodyBase {

	public function new(
		body: Body, anchor: Vec2, space: Space, ?limits: Rect<Float>, isStatic: Bool = false, isBullet: Bool = false, ?group: NapeGroup
	) {
		super(space, limits, isStatic, isBullet, body, anchor, group);
	}

	override private function init(): Void {}

}
