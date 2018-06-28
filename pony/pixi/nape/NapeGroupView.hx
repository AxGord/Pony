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
package pony.pixi.nape;

import haxe.io.Bytes;
import pixi.core.sprites.Sprite;
import pony.geom.Point;
import pony.geom.Rect;
import pony.physics.nape.BodyBase;
import pony.physics.nape.DebugLineStyle;
import pony.physics.nape.NapeGroup;

/**
 * NapeGroupView
 * @author AxGord <axgord@gmail.com>
 */
class NapeGroupView extends Sprite {

	public var debugLines(default, set):DebugLineStyle;

	public var core(default, null):NapeGroup;
	private var objects:Array<BodyBaseView<BodyBase>> = [];

	public function new(core:NapeGroup) {
		super();
		this.core = core;
	}

	public function clear():Void {
		for (o in objects.copy()) o.destroy();
	}

	private function set_debugLines(v:DebugLineStyle):DebugLineStyle {
		debugLines = v;
		for (e in objects) e.debugLines = v;
		return v;
	}

	public function reg<S:BodyBase, T:BodyBaseView<S>>(obj:T):T {
		obj.debugLines = debugLines;
		addChild(obj);
		objects.push(cast obj);
		obj.core.onDestroy < function() {
			removeChild(obj);
			objects.remove(cast obj);
		}
		return obj;
	}

	public function createBox(size:Point<Float>, isBullet:Bool = false):BodyBoxView {
		return reg(new BodyBoxView(core.createBox(size, isBullet)));
	}

	public function createStaticBox(size:Point<Float>, isBullet:Bool = false):BodyBoxView {
		return reg(new BodyBoxView(core.createStaticBox(size, isBullet)));
	}

	public function createRect(size:Rect<Float>, isBullet:Bool = false):BodyRectView {
		return reg(new BodyRectView(core.createRect(size, isBullet)));
	}

	public function createStaticRect(size:Rect<Float>, isBullet:Bool = false):BodyRectView {
		return reg(new BodyRectView(core.createStaticRect(size, isBullet)));
	}

	public function createCircle(r:Float, isBullet:Bool = false):BodyCircleView {
		return reg(new BodyCircleView(core.createCircle(r, isBullet)));
	}

	public function createStaticCircle(r:Float, isBullet:Bool = false):BodyCircleView {
		return reg(new BodyCircleView(core.createStaticCircle(r, isBullet)));
	}

	public function createShape(data:Bytes, resolution:Float, isBullet:Bool = false):BodyShapeView {
		return reg(new BodyShapeView(core.createShape(data, resolution, isBullet)));
	}

}