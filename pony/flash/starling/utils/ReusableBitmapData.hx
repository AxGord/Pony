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
package pony.flash.starling.utils;
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