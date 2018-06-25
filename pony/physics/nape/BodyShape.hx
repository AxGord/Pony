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

import haxe.io.BytesInput;
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

	public static var CACHE:Map<Bytes, Map<Int, GeomPolyList>> = new Map<Bytes, Map<Int, GeomPolyList>>();

	public var sbytes(default, null):Bytes;
	public var resolution(default, null):Float;

	public function new(sbytes:Bytes, resolution:Float, space:Space, ?limits:Rect<Float>, isStatic:Bool = false, isBullet:Bool = false, ?group:NapeGroup) {
		this.sbytes = sbytes;
		this.resolution = resolution;
		super(space, limits, isStatic, isBullet, group);
	}

	override function init():Void {
		var rint:Int = Std.int(resolution * 1000);
		var cbcache = CACHE[sbytes];
		if (cbcache == null) {
			cbcache = new Map();
			CACHE[sbytes] = cbcache;
		}
		var cpolygons:GeomPolyList = cbcache[rint];
		if (cpolygons == null) {
			var bi = new BytesInput(sbytes);
			var pb:Byte = bi.readByte();
			var a:Array<Vec2> = [while (bi.position < bi.length) {
				var p:Byte = bi.readByte();
				new Vec2((p.a - pb.a) * resolution, (p.b - pb.b) * resolution);
			}];
			cpolygons = new GeomPoly(a).convexDecomposition();
			cbcache[rint] = cpolygons;
		}
		for (g in cpolygons) {
			var p = new Polygon(g, material);
			p.sensorEnabled = body.isBullet;
			body.shapes.add(p);
		}
	}

}