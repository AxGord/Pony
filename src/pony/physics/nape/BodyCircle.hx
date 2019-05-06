package pony.physics.nape;

import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.geom.Point;
import pony.geom.Rect;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.space.Space;
import nape.shape.Polygon;
import nape.shape.Circle;

/**
 * BodyCircle
 * @author AxGord <axgord@gmail.com>
 */
class BodyCircle extends BodyBase {

	public var radius(default, null):Float;

	public function new(
		r:Float,
		?pos:Point<Float>,
		space:Space,
		?limits:Rect<Float>,
		isStatic:Bool = false,
		isBullet:Bool = false,
		?group:NapeGroup
	) {
		this.radius = r;
		super(pos, space, limits, isStatic, isBullet, group);
	}

	override private function init():Void {
		var sh = new Circle(radius, material);
		sh.sensorEnabled = body.isBullet;
		body.shapes.add(sh);
	}
	
	override public function getCacheId():Bytes {
		var b:BytesOutput = new BytesOutput();
		b.writeByte(0x03); //shape code
		b.writeInt32(Std.int(radius * 1000));
		return b.getBytes();
	}

}