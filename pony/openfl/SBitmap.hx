package pony.openfl;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;

/**
 * SBitmap
 * @author AxGord <axgord@gmail.com>
 */
class SBitmap extends Bitmap {

	public function new(path:String, pixelSnapping:PixelSnapping=null, smoothing:Bool=true) {
		super(Assets.getBitmapData(path), pixelSnapping == null ? PixelSnapping.AUTO : pixelSnapping, smoothing);
	}
	
}