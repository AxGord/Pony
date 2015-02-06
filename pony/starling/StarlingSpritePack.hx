package pony.starling;

import starling.display.Image;
import starling.display.Sprite;

/**
 * StarlingSpritePack
 * @author AxGord
 */
class StarlingSpritePack extends Sprite {

	private var data:Array<Image>;
	
	public var currentFrame(default, set):Int = 0;
	
	public function new(a:Array<Image>) {
		super();
		data = a;
		addChild(a[0]);
	}
	
	public function set_currentFrame(frame:Int):Int {
		if (frame < 0 || frame >= data.length) throw 'Uncorrect frame';
		//trace(frame);
		removeChild(data[currentFrame]);
		addChild(data[frame]);
		currentFrame = frame;
		return frame;
	}
	
}