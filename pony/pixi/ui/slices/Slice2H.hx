package pony.pixi.ui.slices;

using pony.pixi.PixiExtends;

/**
 * Slice2H
 * @author AxGord <axgord@gmail.com>
 */
class Slice2H extends Slice3H {
	
	public function new(data:Array<String>, ?useSpriteSheet:String, creep:Float = 0) {
		data.push(data[0]);
		super(data, useSpriteSheet, creep);
	}
	
	override function init():Void {
		super.init();
		images[2].flipX();
	}
	
	override function update():Void {
		if (!inited) return;
		super.update();
		images[2].flipXpos();
	}
	
}