package pony.pixi.ui;

import pony.geom.Point;

/**
 * FSButton
 * @author AxGord <axgord@gmail.com>
 */
class FSButton extends Button {

	private var fs:FSButtonCore;
	
	public function new(imgs:ImmutableArray<String>, ?offset:Point<Float>, ?useSpriteSheet:String) {
		super(imgs, offset, useSpriteSheet);
		fs = new FSButtonCore();
		fs.onEnable = fsEnableHandler;
		fs.onDisable = fsDisableHandler;
		core.onClick - 1 << fs.fsOff;
		core.onClick - 0 << fs.fsOn;
	}
	
	private function fsEnableHandler():Void core.bMode = true;
	private function fsDisableHandler():Void core.bMode = false;
	
}