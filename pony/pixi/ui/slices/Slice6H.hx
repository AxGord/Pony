package pony.pixi.ui.slices;

using pony.pixi.PixiExtends;

/**
 * Slice6H
 * @author AxGord <axgord@gmail.com>
 */
class Slice6H extends Slice9 {
	
	public function new(data:Array<String>, ?useSpriteSheet:String, creep:Float = 0) {
		data = [
			data[0], data[1], data[0],
			data[2], data[3], data[2],
			data[4], data[5], data[4]
		];
		super(data, useSpriteSheet, creep);
	}
	
	override function init():Void {
		super.init();
		images[2].flipX();
		images[5].flipX();
		images[8].flipX();
	}
	
	override function updateWidth():Void {
		if (!inited) return;
		super.updateWidth();
		images[2].flipXpos();
		images[5].flipXpos();
		images[8].flipXpos();
	}
	
}