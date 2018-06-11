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

import nape.callbacks.InteractionCallback;
import pony.geom.Point;
import pony.geom.Rect;
import pony.events.Signal2;
import pony.events.Event2;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;
import nape.callbacks.InteractionListener;
import nape.space.Space;
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

	public function createCircle(r:Float, isBullet:Bool = false, isBullet:Bool = false):BodyCircle {
		return new BodyCircle(r, space, ns.limits, false, isBullet, this);
	}

	public function createStaticCircle(r:Float, isBullet:Bool = false):BodyCircle {
		return new BodyCircle(r, space, ns.limits, true, isBullet, this);
	}

}