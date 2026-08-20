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
 * BodyRect
 * @author AxGord <axgord@gmail.com>
 */
class BodyRect extends BodyBase {

	public var size(default, null): Rect<Float>;

	public function new(
		size: Rect<Float>, space: Space, ?limits: Rect<Float>, isStatic: Bool = false, isBullet: Bool = false, ?group: NapeGroup
	) {
		this.size = size;
		super(space, limits, isStatic, isBullet, group);
	}

	override private function init(): Void {
		final sh = new Polygon(Polygon.rect(size.x, size.y, size.width, size.height), material);
		sh.sensorEnabled = body.isBullet;
		body.shapes.add(sh);
	}

	override public function getCacheId(): Bytes {
		final b: BytesOutput = new BytesOutput();
		b.writeByte(0x02); // shape code
		b.writeInt32(Std.int(size.x * 1000));
		b.writeInt32(Std.int(size.y * 1000));
		b.writeInt32(Std.int(size.width * 1000));
		b.writeInt32(Std.int(size.height * 1000));
		return b.getBytes();
	}

}
