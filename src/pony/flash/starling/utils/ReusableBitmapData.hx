package pony.flash.starling.utils;

import flash.display.BitmapData;

/**
 * ReusableBitmapData
 * @author Maletin
 */
class ReusableBitmapData {

	private static inline final _sizeLimit: Int = 4096;
	private static inline final _fillColor: Int = 0x0;
	private static final _instance: ReusableBitmapData = new ReusableBitmapData();

	private final _cache: Map<Int, Map<Int, BitmapData>> = [];

	public function new() {
		if (_instance != null) throw 'Singletone creation error';

		var i: Int = 1;
		while (i <= _sizeLimit) { // Starling texture size limit
			_cache[i] = new Map<Int, BitmapData>();
			i *= 2;
		}
	}

	public static function getPowTwo(width: Int, height: Int): BitmapData {
		width = PowerOfTwo.getNextPowerOfTwo(width);
		height = PowerOfTwo.getNextPowerOfTwo(height);

		if (width > _sizeLimit) width = _sizeLimit;
		if (height > _sizeLimit) height = _sizeLimit;

		var bmpd: BitmapData;
		final cacheWidth = _instance._cache[width];
		if (cacheWidth.exists(height))
		// if (false)
		{
			bmpd = cacheWidth.get(height);
			bmpd.fillRect(bmpd.rect, _fillColor);
		} else {
			bmpd = new BitmapData(width, height, true, _fillColor);
			cacheWidth.set(height, bmpd);
		}

		return bmpd;
	}

}
