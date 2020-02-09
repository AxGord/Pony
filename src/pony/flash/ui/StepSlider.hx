package pony.flash.ui;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import pony.math.MathTools;
import pony.time.DeltaTime;
import pony.ui.gui.StepSliderCore;
import pony.flash.FLStage;

/**
 * StepSlider
 * @author AxGord <axgord@gmail.com>
 */
class StepSlider extends MovieClip implements FLStage {

	#if !starling
	public var core(default, null): StepSliderCore;

	private var _invert: Bool = false;
	@:stage private var b: Button;
	@:stage private var bg: DisplayObject;

	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
	}

	private function init(): Void {
		core = StepSliderCore.create(b.core, bg.width - b.width, bg.height - b.height, _invert);
		core.changeX = function(v) b.x = v;
		core.changeY = function(v) b.y = v;
		core.endInit();
	}

	private function invert(): Void _invert = true;
	#end

}