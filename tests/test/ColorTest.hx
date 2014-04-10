package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.color.Color;
import pony.color.UColor;

class ColorTest 
{
	@Test
	public function split():Void
	{
		var c:UColor = 0xFF559922;
		Assert.areEqual(c.a, 0xFF);
		Assert.areEqual(c.r, 0x55);
		Assert.areEqual(c.g, 0x99);
		Assert.areEqual(c.b, 0x22);
		
		Assert.areEqual(c.af, 1);
		Assert.areEqual(c.gf, 0.6);
	}
	
	@Test
	public function parse():Void {
		var c:UColor = '#3388CC';
		Assert.areEqual(c, 0x3388CC);
	}
	
	@Test
	public function rgb():Void {
		var c:UColor = 'rgb(255, 0, 155)';
		Assert.areEqual(c, 0xFF009B);
	}
	
	@Test
	public function argb():Void {
		var c:UColor = 'argb(120, 255, 0, 155)';
		Assert.areEqual(c, 0x78FF009B);
	}
	
	@Test
	public function addNegative():Void {
		var a:Color = new Color(0, 255, -67, 0);
		var b:Color = new Color(0, 66, 66, 66);
		var c:Color = b + a;
		Assert.areEqual(c.a, 0);
		Assert.areEqual(c.r, 255);
		Assert.areEqual(c.g, -1);
		Assert.areEqual(c.b, 66);
		Assert.isTrue(c == new UColor(0xFF0042));
	}
}