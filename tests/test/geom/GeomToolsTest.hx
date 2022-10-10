package geom;

import massive.munit.Assert;

import pony.geom.GeomTools;
import pony.geom.Point;

class GeomToolsTest {

	@Test
	public function p4(): Void {
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
	public function center(): Void {
		var c = new Point<Float>(10, 10);
		var a = [new Point<Float>(2, 3), new Point<Float>(4, 1)];
		var r = GeomTools.pointsCeil(GeomTools.center(c, a, true));
		Assert.areEqual(r[0].y, 2);
		Assert.areEqual(r[1].y, 7);
		Assert.areEqual(r[0].x, 4);
		Assert.areEqual(r[1].x, 3);
	}

}