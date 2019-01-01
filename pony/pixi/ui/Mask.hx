package pony.pixi.ui;

import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;

/**
 * Mask
 * @author AxGord <axgord@gmail.com>
 */
class Mask extends Sprite {
	
	public var objMask:Graphics;

	public function new(w:Float, h:Float, radius:Int, obj:Sprite) {
		super();
		objMask = new Graphics();
		objMask.beginFill(0x666666);
		objMask.drawRoundedRect(0, 0, w, h, radius);
		obj.mask = objMask;
		addChild(objMask);
		addChild(obj);
	}
	
}