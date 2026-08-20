package pony.physics.nape;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;
import pony.Byte;
import pony.geom.Rect;

/**
 * BodyShape
 * @author AxGord <axgord@gmail.com>
 */
class BodyShape extends BodyBase {

	public static var CACHE: Map<String, GeomPolyList> = [];

	public var sbytes(default, null): Bytes;
	public var resolution(default, null): Float;

	public function new(
		sbytes: Bytes, resolution: Float, space: Space, ?limits: Rect<Float>, isStatic: Bool = false, isBullet: Bool = false,
		?group: NapeGroup
	) {
		this.sbytes = sbytes;
		this.resolution = resolution;
		super(space, limits, isStatic, isBullet, group);
	}

	override public function getCacheId(): Bytes {
		final b: BytesOutput = new BytesOutput();
		b.writeByte(0x00); // shape code
		b.writeInt32(Std.int(resolution * 1000));
		b.write(sbytes);
		return b.getBytes();
	}

	override private function init(): Void {
		final cid: String = getCacheId().toHex();
		var cpolygons: GeomPolyList = CACHE[cid];
		if (cpolygons == null) {
			final bi: BytesInput = new BytesInput(sbytes);
			final pb: Byte = bi.readByte();
			final a: Array<Vec2> = [
				while (bi.position < bi.length) {
					final p: Byte = bi.readByte();
					new Vec2((p.a - pb.a) * resolution, (p.b - pb.b) * resolution);
				}
			];
			cpolygons = new GeomPoly(a).convexDecomposition();
			CACHE[cid] = cpolygons;
		}
		for (g in cpolygons) {
			final p = new Polygon(g, material);
			p.sensorEnabled = body.isBullet;
			body.shapes.add(p);
		}
	}

}
