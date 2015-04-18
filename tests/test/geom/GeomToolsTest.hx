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
}