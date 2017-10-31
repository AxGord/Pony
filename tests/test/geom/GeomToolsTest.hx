/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package geom;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.geom.GeomTools;
import pony.geom.Point;

class GeomToolsTest 
{
	@Test
	public function p4():Void
	{
		var points = [
			new Point(-73, -85),
			new Point(-33, -126),
			new Point(7, -85),
			new Point(-33, -45)
		];
		
		Assert.isTrue(GeomTools.inPoly(new Point(-40, -60), points));
		Assert.isFalse(GeomTools.inPoly(new Point(40, -60), points));
		Assert.isFalse(GeomTools.inPoly(new Point(-40, 60), points));
	}
	
	@Test
	public function center():Void {
		var c = new Point<Float>(10, 10);
		var a = [
			new Point<Float>(2, 3),
			new Point<Float>(4, 1)
		];
		var r = GeomTools.pointsCeil(GeomTools.center(c, a, true));
		Assert.areEqual(r[0].y, 2);
		Assert.areEqual(r[1].y, 7);
		Assert.areEqual(r[0].x, 4);
		Assert.areEqual(r[1].x, 3);
	}
	
}