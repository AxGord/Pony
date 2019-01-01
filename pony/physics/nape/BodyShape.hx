package pony.physics.nape;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.Byte;
import pony.geom.Point;
import pony.geom.Rect;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.space.Space;
import nape.shape.Shape;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;

/**
 * BodyShape
 * @author AxGord <axgord@gmail.com>
 */
class BodyShape extends BodyBase {

	public static var CACHE:Map<String, GeomPolyList> = new Map<String, GeomPolyList>();

	public var sbytes(default, null):Bytes;
	public var resolution(default, null):Float;

	public function new(sbytes:Bytes, resolution:Float, space:Space, ?limits:Rect<Float>, isStatic:Bool = false, isBullet:Bool = false, ?group:NapeGroup) {
		this.sbytes = sbytes;
		this.resolution = resolution;
		super(space, limits, isStatic, isBullet, group);
	}

	override function init():Void {
		var cid = getCacheId().toHex();
		var cpolygons:GeomPolyList = CACHE[cid];
		if (cpolygons == null) {
			var bi = new BytesInput(sbytes);
			var pb:Byte = bi.readByte();
			var a:Array<Vec2> = [while (bi.position < bi.length) {
				var p:Byte = bi.readByte();
				new Vec2((p.a - pb.a) * resolution, (p.b - pb.b) * resolution);
			}];
			cpolygons = new GeomPoly(a).convexDecomposition();
			CACHE[cid] = cpolygons;
		}
		for (g in cpolygons) {
			var p = new Polygon(g, material);
			p.sensorEnabled = body.isBullet;
			body.shapes.add(p);
		}
	}

	override public function getCacheId():Bytes {
		var b:BytesOutput = new BytesOutput();
		b.writeByte(0x00); //shape code
		b.writeInt32(Std.int(resolution * 1000));
		b.write(sbytes);
		return b.getBytes();
	}

}