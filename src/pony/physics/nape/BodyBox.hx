package pony.physics.nape;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import pony.geom.Point;
import pony.geom.Rect;

/**
 * BodyBox
 * @author AxGord <axgord@gmail.com>
 */
class BodyBox extends BodyBase {

	public var size(default, null): Point<Float>;

	public function new(
		size: Point<Float>, space: Space, ?limits: Rect<Float>, isStatic: Bool = false, isBullet: Bool = false, ?group: NapeGroup
	) {
		this.size = size;
		super(space, limits, isStatic, isBullet, group);
	}

	override public function getCacheId(): Bytes {
		final b: BytesOutput = new BytesOutput();
		b.writeByte(0x01); // shape code
		b.writeInt32(Std.int(size.x * 1000));
		b.writeInt32(Std.int(size.y * 1000));
		return b.getBytes();
	}

	override private function init(): Void {
		final sh = new Polygon(Polygon.box(size.x, size.y), material);
		sh.sensorEnabled = body.isBullet;
		body.shapes.add(sh);
	}

}
