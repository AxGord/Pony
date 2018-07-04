/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package pony.physics.nape;

import haxe.io.Bytes;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.space.Space;
import nape.callbacks.CbType;
import nape.callbacks.CbEvent;
import nape.callbacks.BodyListener;
import nape.callbacks.BodyCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.Listener;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import pony.events.Event0;
import pony.events.Event1;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.geom.Point;
import pony.geom.Rect;
import pony.time.DeltaTime;
import pony.math.MathTools;

/**
 * BodyBase
 * @author AxGord <axgord@gmail.com>
 */
class BodyBase implements pony.magic.HasSignal implements pony.magic.HasLink implements pony.magic.HasAbstract {

	public static var BODYMAP:Map<Int, BodyBase> = new Map<Int, BodyBase>();

	@:auto public var onDestroy:Signal0;
	@:auto public var onPos:Signal2<Float, Float>;
	@:auto public var onRotation:Signal1<Float>;
	@:auto public var onOut:Signal0;

	public var pos(get, set):Point<Float>;
	public var angularVel(link, link):Float = body.angularVel;
	public var rotation(link, link):Float = body.rotation;

	public var body(default, null):Body;
	private var cbt:CbType;
	private var addedListeners:Array<Listener> = [];
	private var events0:Array<Event0> = [];
	private var events1:Array<Event1<Int>> = [];
	private var material:Material;
	private var lookAtTarget:Float;
	private var lookAtVelocity:Float;
	private var lookAtDirrect:Int;

	public var limits:Rect<Float>;

	public var group(default, null):NapeGroup;

	private function new(space:Space, limits:Rect<Float>, isStatic:Bool = false, isBullet:Bool = false, ?group:NapeGroup) {
		this.limits = limits;
		this.group = group;
		body = new Body(isStatic ? BodyType.STATIC : BodyType.KINEMATIC);
		BODYMAP[body.id] = this;
		body.isBullet = isBullet;
		init();
		body.space = space;
		cbt = new CbType();
		body.cbTypes.add(cbt);
		if (group != null)
			body.cbTypes.add(group.cbt);
		if (!isStatic) {
			addListener(new BodyListener(CbEvent.WAKE, cbt, wakeHandler));
			addListener(new BodyListener(CbEvent.SLEEP, cbt, sleepHandler));
			pony.time.DeltaTime.update << updateHandler;
		}
	}

	public function getCacheId():Bytes return null;

	public inline function scale(x:Float, y:Float):Void {
		body.scaleShapes(x, y);
	}

	public inline function lookAt(x:Float, y:Float):Void {
		rotation = Math.atan2(y - pos.y, x - pos.x);
	}

	public function lookAtVelLin(x:Float, y:Float, vel:Float):Void {
		lookAtVelocity = vel;
		lookAtTarget = Math.atan2(y - pos.y, x - pos.x);
		lookAtDirrect = lookAtTarget > rotation ? 1 : -1;
		if (lookAtTarget == rotation) lookAtDirrect = 0;
		angularVel = lookAtDirrect * vel;
		if (lookAtDirrect != 0) {
			pony.time.DeltaTime.update.add(checkLookAtHandler, 2);
			checkLookAtHandler();
		}
	}

	private function checkLookAtHandler():Void {
		if ( (lookAtDirrect == 1 && lookAtTarget <= rotation + MathTools.DEG2RAD * angularVel)
			|| (lookAtDirrect == -1 && lookAtTarget >= rotation + MathTools.DEG2RAD * angularVel)
		) {
			angularVel = 0;
			rotation = lookAtTarget;
			pony.time.DeltaTime.update >> checkLookAtHandler;
		}
	}

	public inline function lookAtPoint(p:Point<Float>):Void {
		lookAt(p.x, p.y);
	}

	public inline function setSpeed(v:Float):Void {
		body.velocity = new Vec2(v * Math.cos(rotation), v * Math.sin(rotation));
	}

	private function addListener<T:Listener>(l:T):Void {
		addedListeners.push(l);
		body.space.listeners.add(l);
	}

	private function createEvent0():Event0 {
		var e = new Event0();
		events0.push(e);
		return e;
	}

	private function createEvent1():Event1<Int> {
		var e = new Event1<Int>();
		events1.push(e);
		return e;
	}

	@:abstract private function init():Void;

	private function updateHandler():Void {
		ePos.dispatch(body.position.x, body.position.y);
		eRotation.dispatch(body.rotation);
		if (limits != null) {
			var mx = body.bounds.width * 2;
			var my = body.bounds.height * 2;
			if (body.position.x < limits.x - mx
			|| body.position.x > limits.width + mx
			|| body.position.y < limits.y - my
			|| body.position.y > limits.height + my)
				eOut.dispatch();
		}
	}

	private function wakeHandler(_):Void {
		DeltaTime.update < wake;
	}

	private function wake():Void {
		DeltaTime.update << updateHandler;
	}

	private function sleepHandler(_):Void {
		DeltaTime.update < sleep;
	}

	private function sleep():Void {
		DeltaTime.update >> updateHandler;
	}

	public function groupCollision<T:NapeGroup>(with:T):Signal1<Int> {
		var e = createEvent1();
		body.space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			with.sensor ? InteractionType.SENSOR : InteractionType.COLLISION,
			cbt,
			with.cbt,
			function(ic:InteractionCallback):Void e.dispatch(ic.int2.id)
		));
		return e;
	}

	public function collision<T:BodyBase>(with:T):Signal0 {
		var e = createEvent0();
		body.space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			body.isBullet ? InteractionType.SENSOR : InteractionType.COLLISION,
			cbt,
			with.cbt,
			function(_) e.dispatch()
		));
		return e;
	}

	public function collisionLost<T:BodyBase>(with:T):Signal0 {
		var e = new Event0();
		addListener(new InteractionListener(
			CbEvent.END,
			body.isBullet ? InteractionType.SENSOR : InteractionType.COLLISION,
			cbt,
			with.cbt,
			function(_) e.dispatch()
		));
		return e;
	}

	private function get_pos():Point<Float> {
		return new Point<Float>(body.position.x, body.position.y);
	}

	private function set_pos(p:Point<Float>):Point<Float> {
		body.position.setxy(p.x, p.y);
		ePos.dispatch(p.x, p.y);
		return p;
	}

	public function destroy():Void {
		if (body == null) return;
		DeltaTime.update >> updateHandler;
		if (body.space != null)
			for (l in addedListeners)
				body.space.listeners.remove(l);
		addedListeners = null;
		for (e in events0) e.destroy();
		events0 = null;
		for (e in events1) e.destroy();
		events1 = null;
		body.cbTypes.remove(cbt);
		cbt = null;
		body.space = null;
		BODYMAP.remove(body.id);
		body = null;
		eDestroy.dispatch();
		destroySignals();
	}

}