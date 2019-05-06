package pony.physics.nape;

import haxe.io.Bytes;
import pony.geom.Point;
import pony.geom.Rect;
import pony.time.DeltaTime;
import pony.time.DT;
import nape.phys.Body;
import nape.space.Space;
import nape.geom.Vec2;

/**
 * NapeSpace
 * @author AxGord <axgord@gmail.com>
 */
@:forward()
abstract NapeSpace(NapeSpaceBase) from NapeSpaceBase to NapeSpaceBase {
	
	public inline function new(w:Float, h:Float, ?gravity:Point<Float>):Void {
		this = new NapeSpaceBase(w, h, gravity);
	}

	@:op(a.b) public inline function resolve(s:String):NapeGroup {
		return this.resolve(s);
	}
}

/**
 * NapeSpaceBase
 * @author AxGord <axgord@gmail.com>
 */
class NapeSpaceBase {

	public var space:Space;
	public var minimalStep(default, null):Float;
	private var skipVelIntegrations:Int;
	public var width:Float;
	public var height:Float;
	public var minSide(get, never):Float;
	public var maxSide(get, never):Float;
	public var snap(get, never):Float;
	public var limits:Rect<Float>;
	private var groups:Map<String, NapeGroup> = new Map<String, NapeGroup>();

	public function new(w:Float, h:Float, ?gravity:Point<Float>, minimalStep:Float = 1 / 60, skipVelIntegrations:Int = 10) {
		this.width = w;
		this.height = h;
		limits = new Rect<Float>(0, 0, w, h);
		space = new Space(gravity != null ? Vec2.weak(gravity.x, gravity.y) : null);
		this.minimalStep = minimalStep;
		this.skipVelIntegrations = skipVelIntegrations;
	}

	@:extern private inline function get_minSide():Float return Math.min(width, height);
	@:extern private inline function get_maxSide():Float return Math.max(width, height);
	@:extern private inline function get_snap():Float return minSide / 100;

	public function resolve(name:String):NapeGroup {
		if (!groups.exists(name))
			groups[name] = new NapeGroup(this);
		return groups[name];
	}

	public function play():Void {
		DeltaTime.update.add(update, 1);
	}

	public function pause():Void {
		DeltaTime.update >> update;
	}

	public function update(dt:DT):Void {
		var f:Float = dt;
		var integrations:Int = Std.int(f / minimalStep);
		var sumf:Float = minimalStep * integrations;
		f -= sumf;
		if (integrations > 0) {
			var vi:Int = Std.int(integrations / skipVelIntegrations);
			if (vi == 0) vi = 1;
			space.step(sumf, vi, integrations);
		}
		if (f > 0)
			space.step(f, 1, 1);
	}

	public function createBox(size:Point<Float>, isBullet:Bool = false):BodyBox {
		return new BodyBox(size, space, limits, false, isBullet);
	}

	public function createStaticBox(size:Point<Float>, isBullet:Bool = false):BodyBox {
		return new BodyBox(size, space, limits, true, isBullet);
	}

	public function createRect(size:Rect<Float>, isBullet:Bool = false):BodyRect {
		return new BodyRect(size, space, limits, false, isBullet);
	}

	public function createStaticRect(size:Rect<Float>, isBullet:Bool = false):BodyRect {
		return new BodyRect(size, space, limits, true, isBullet);
	}

	public function createCircle(r:Float, isBullet:Bool = false, isBullet:Bool = false):BodyCircle {
		return new BodyCircle(r, space, limits, false, isBullet);
	}

	public function createStaticCircle(r:Float, pos:Point<Float>, isBullet:Bool = false):BodyCircle {
		return new BodyCircle(r, pos, space, limits, true, isBullet);
	}

	public function createShape(data:Bytes, resolution:Float, isBullet:Bool = false):BodyShape {
		return new BodyShape(data, resolution, space, limits, false, isBullet);
	}

	public function createBody(data:Body, ?anchor:Vec2, isStatic:Bool = false, isBullet:Bool = false):BodyBody {
		return new BodyBody(data, anchor, space, limits, isStatic, isBullet);
	}

}