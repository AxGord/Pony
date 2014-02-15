package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.Color;

class ColorTest 
{
	@Test
	public function split():Void
	{
		var c:Color = 0xFF559922;
		Assert.areEqual(c.a, 0xFF);
		Assert.areEqual(c.r, 0x55);
		Assert.areEqual(c.g, 0x99);
		Assert.areEqual(c.b, 0x22);
		
		Assert.areEqual(c.af, 1);
		Assert.areEqual(c.gf, 0.6);
	}
	
	@Test
	public function parse():Void {
		var c:Color = '#3388CC';
		Assert.areEqual(c, 0x3388CC);
	}
	
	@Test
	public function rgb():Void {
		var c:Color = 'rgb(255, 0, 155)';
		Assert.areEqual(c, 0xFF009B);
	}
	
	@Test
	public function argb():Void {
		var c:Color = 'argb(120, 255, 0, 155)';
		Assert.areEqual(c, 0x78FF009B);
	}
}