package pony.pixi.ui.slices;

import pixi.core.sprites.Sprite;

using pony.pixi.PixiExtends;

/**
 * SliceSprite
 * @author AxGord <axgord@gmail.com>
 */
class SliceSprite extends Sprite {
	
	public var sliceWidth(default, set):Float;
	public var sliceHeight(default, set):Float;
	
	private var inited:Bool = false;
	private var images:Array<Sprite>;
	private var creep:Float;
	
	public function new(data:Array<String>, ?useSpriteSheet:String, creep:Float = 0) {
		super();
		this.creep = creep;
		if (useSpriteSheet != null)
			images = [for (e in data) PixiAssets.image(useSpriteSheet, e)];
		else
			images = [for (e in data) PixiAssets.image(e)];
		images.loadedList(init);
	}
	
	private function init():Void {
		inited = true;
		if (sliceWidth != null) {
			sliceWidth = sliceWidth;
		} else {
			sliceWidth = images[0].width;
		}
		if (sliceHeight != null) {
			sliceHeight = sliceHeight;
		} else {
			sliceHeight = images[0].height;
		}
		for (img in images) addChild(img);
	}
	
	private function set_sliceWidth(v:Float):Float {
		sliceWidth = v;
		if (!inited) return v;
		for (img in images) img.width = v;
		return v;
	}
	
	private function set_sliceHeight(v:Float):Float {
		sliceHeight = v;
		if (!inited) return v;
		for (img in images) img.height = v;
		return v;
	}
	
	
}