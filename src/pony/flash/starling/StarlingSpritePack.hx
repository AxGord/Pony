package pony.flash.starling;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import pony.flash.FLTools;
import pony.flash.starling.converter.AtlasCreator;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

/**
 * StarlingSpritePack
 * @author AxGord
 */
class StarlingSpritePack extends Sprite {

	public var currentFrame(default, set): Int = 0;

	private final data: Array<Image>;

	public function new(a: Array<Image>) {
		super();
		data = a;
		addChild(a[0]);
	}

	public function set_currentFrame(frame: Int): Int {
		if (frame < 0 || frame >= data.length) throw 'Uncorrect frame';
		// trace(frame);
		removeChild(data[currentFrame]);
		addChild(data[frame]);
		currentFrame = frame;
		return frame;
	}

	public static function builder(
		atlasCreator: AtlasCreator, source: DisplayObject, coordinateSpace: DisplayObject, disposeable: Bool = false
	): starling.display.DisplayObject {
		final m: SpritePack = cast source;
		final a: Array<Image> = [];

		for (f in 1...(m.totalFrames + 1)) {
			m.gotoAndStop(f);
			var bitmap: BitmapData = new BitmapData(Std.int(Math.min(FLTools.width, m.width)), Std.int(Math.min(FLTools.height, m.height)));
			bitmap.draw(m);
			a.push(new Image(Texture.fromBitmapData(bitmap)));
			bitmap.dispose();
		}
		return new StarlingSpritePack(a);
	}

}
