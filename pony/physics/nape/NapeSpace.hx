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
import pony.geom.Point;
import pony.geom.Rect;
import pony.time.DeltaTime;
import pony.time.DT;
import nape.space.Space;
import nape.geom.Vec2;

/**
 * NapeSpace
 * @author AxGord <axgord@gmail.com>
 */
class NapeSpace implements Dynamic<NapeGroup> {

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

	public function createStaticCircle(r:Float, isBullet:Bool = false):BodyCircle {
		return new BodyCircle(r, space, limits, true, isBullet);
	}

	public function createShape(data:Bytes, resolution:Float, isBullet:Bool = false):BodyShape {
		return new BodyShape(data, resolution, space, limits, false, isBullet);
	}

}