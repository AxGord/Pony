package pony.pixi.ui.slices;

using pony.pixi.PixiExtends;

/**
 * Slice6V
 * @author AxGord <axgord@gmail.com>
 */
class Slice6V extends Slice9 {
	
	public function new(data:Array<String>, ?useSpriteSheet:String, creep:Float = 0) {
		data = [
			data[0], data[1], data[2],
			data[3], data[4], data[5],
			data[0], data[1], data[2]
		];
		super(data, useSpriteSheet, creep);
	}
	
	override function init():Void {
		super.init();
		for (i in 6...9) images[i].flipY();
	}
	
	override function updateHeight():Void {
		if (!inited) return;
		super.updateHeight();
		for (i in 6...9) images[i].flipYpos();
	}
	
}