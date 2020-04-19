package pony.physics.nape;

import haxe.io.Bytes;
import nape.callbacks.InteractionCallback;
import pony.geom.Point;
import pony.geom.Rect;
import pony.events.Signal2;
import pony.events.Event2;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;
import nape.callbacks.InteractionListener;
import nape.space.Space;
import nape.phys.Body;
import nape.geom.Vec2;
import nape.callbacks.CbType;

/**
 * NapeGroup
 * @author AxGord <axgord@gmail.com>
 */
class NapeGroup {

	public var cbt:CbType = new CbType();
	private var space:Space;
	private var ns:NapeSpace;
	public var sensor:Bool = true;

	public function new(ns:NapeSpace) {
		this.ns = ns;
		this.space = ns.space;
	}

	public function collision(with:NapeGroup):Signal2<BodyBase, BodyBase> {
		var e = new Event2<BodyBase, BodyBase>();
		space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			sensor ? InteractionType.SENSOR : InteractionType.COLLISION,
			cbt,
			with.cbt,
			function(cb:InteractionCallback) if (cb.arbiters.length > 0) {
				var a = cb.arbiters.iterator().next();
				e.dispatch(BodyBase.BODYMAP[a.body1.id], BodyBase.BODYMAP[a.body2.id]);
			}
		));
		return e;
	}

	public function createBox(size:Point<Float>, isBullet:Bool = false):BodyBox {
		return new BodyBox(size, space, ns.limits, false, isBullet, this);
	}

	public function createStaticBox(size:Point<Float>, isBullet:Bool = false):BodyBox {
		return new BodyBox(size, space, ns.limits, true, isBullet, this);
	}

	public function createRect(size:Rect<Float>, isBullet:Bool = false):BodyRect {
		return new BodyRect(size, space, ns.limits, false, isBullet, this);
	}

	public function createStaticRect(size:Rect<Float>, isBullet:Bool = false):BodyRect {
		return new BodyRect(size, space, ns.limits, true, isBullet, this);
	}

	public function createCircle(r:Float, isBullet:Bool = false):BodyCircle {
		return new BodyCircle(r, space, ns.limits, false, isBullet, this);
	}

	public function createStaticCircle(r:Float, isBullet:Bool = false):BodyCircle {
		return new BodyCircle(r, space, ns.limits, true, isBullet, this);
	}

	public function createShape(data:Bytes, resolution:Float, isBullet:Bool = false):BodyShape {
		return new BodyShape(data, resolution, space, ns.limits, false, isBullet, this);
	}

	public function createBody(data:Body, ?anchor:Vec2, isBullet:Bool = false, isStatic:Bool = false):BodyBody {
		return new BodyBody(data, anchor, space, ns.limits, isStatic, isBullet, this);
	}

}