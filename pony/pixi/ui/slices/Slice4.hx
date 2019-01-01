package pony.pixi.ui.slices;

import pixi.core.math.Point;

using pony.pixi.PixiExtends;

/**
 * Slice4
 * @author AxGord <axgord@gmail.com>
 */
class Slice4 extends Slice9 {
	
	public function new(data:Array<String>, ?useSpriteSheet:String, creep:Float = 0) {
		data = [
			data[0], data[1], data[0],
			data[2], data[3], data[2],
			data[0], data[1], data[0]
		];
		super(data, useSpriteSheet, creep);
	}
	
	override function init():Void {
		super.init();
		images[2].flipX();
		images[5].flipX();
		images[8].flipX();
		for (i in 6...9) images[i].flipY();
	}
	
	override function updateWidth():Void {
		if (!inited) return;
		super.updateWidth();
		images[2].flipXpos();
		images[5].flipXpos();
		images[8].flipXpos();
	}
	
	override function updateHeight():Void {
		if (!inited) return;
		super.updateHeight();
		for (i in 6...9) images[i].flipYpos();
	}
	
}