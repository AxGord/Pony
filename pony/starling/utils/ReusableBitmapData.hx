package pony.starling.utils;
import flash.display.BitmapData;

/**
 * ReusableBitmapData
 * @author Maletin
 */
class ReusableBitmapData 
{
	private static var _instance:ReusableBitmapData = new ReusableBitmapData();
	private static var _sizeLimit:Int = 4096;
	private static var _fillColor:Int = 0x0;
	
	private var _cache:Map<Int, Map<Int, BitmapData>> = new Map<Int, Map<Int, BitmapData>>();

	public function new() 
	{
		if (_instance != null) throw "Singletone creation error";
		
		var i:Int = 1;
		while (i <= _sizeLimit) //Starling texture size limit
		{
			_cache.set(i, new Map<Int, BitmapData>());
			i *= 2;
		}
	}
	
	public static function getPowTwo(width:Int, height:Int):BitmapData
	{
		width = PowerOfTwo.getNextPowerOfTwo(width);
		height = PowerOfTwo.getNextPowerOfTwo(height);
		
		if (width > _sizeLimit) width = _sizeLimit;
		if (height > _sizeLimit) height = _sizeLimit;
		
		var bmpd:BitmapData = null;
		var cacheWidth = _instance._cache.get(width);
		if (cacheWidth.exists(height))
		//if (false)
		{
			bmpd = cacheWidth.get(height);
			bmpd.fillRect(bmpd.rect, _fillColor);
		}
		else
		{
			bmpd = new BitmapData(width, height, true, _fillColor);
			cacheWidth.set(height, bmpd);
		}
		
		return bmpd;
	}
}