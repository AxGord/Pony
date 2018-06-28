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

import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.geom.Point;
import pony.geom.Rect;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.space.Space;
import nape.shape.Polygon;

/**
 * BodyBox
 * @author AxGord <axgord@gmail.com>
 */
class BodyBox extends BodyBase {

	public var size(default, null):Point<Float>;

	public function new(size:Point<Float>, space:Space, ?limits:Rect<Float>, isStatic:Bool = false, isBullet:Bool = false, ?group:NapeGroup) {
		this.size = size;
		super(space, limits, isStatic, isBullet, group);
	}

	override function init():Void {
		var sh = new Polygon(Polygon.box(size.x, size.y), material);
		sh.sensorEnabled = body.isBullet;
		body.shapes.add(sh);
	}

	override public function getCacheId():Bytes {
		var b:BytesOutput = new BytesOutput();
		b.writeByte(0x01); //shape code
		b.writeInt32(Std.int(size.x * 1000));
		b.writeInt32(Std.int(size.y * 1000));
		return b.getBytes();
	}

}