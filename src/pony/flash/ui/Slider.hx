package pony.flash.ui;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import pony.flash.FLStage;
import pony.time.DeltaTime;
import pony.ui.gui.SliderCore;

/**
 * Slider
 * @author AxGord <axgord@gmail.com>
 */
class Slider extends MovieClip implements FLStage {
#if !starling
	public var core(default, null):SliderCore;
	private var _invert:Bool = false;
	@:stage private var b:Button;
	@:stage private var bg:DisplayObject;
	
	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
	}
	
	private function init():Void {
		core = SliderCore.create(b.core, bg.width-b.width, bg.height-b.height);
		core.changeX = function(v) b.x = v; 
		core.changeY = function(v) b.y = v; 
		core.endInit();
	}
	
	private function invert():Void _invert = true;
#end
}