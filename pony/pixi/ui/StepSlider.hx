package pony.pixi.ui;

import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pony.geom.Border;
import pony.geom.Point;
import pony.ui.gui.StepSliderCore;

/**
 * StepSlider
 * @author AxGord <axgord@gmail.com>
 */
class StepSlider extends Sprite {

	public var sliderCore:StepSliderCore;
	public var labelButton:LabelButton;
	
	public function new(
		labelButton:LabelButton,
		w:Float,
		h:Float,
		invert:Bool = false,
		draggable:Bool = true
	) {
		super();
		this.labelButton = labelButton;
		addChild(labelButton);
		sliderCore = StepSliderCore.create(labelButton.core, w, h, invert, draggable);
		sliderCore.changeX = changeXHandler;
		sliderCore.changeY = changeXHandler;
	}
	
	private function changeXHandler(v:Float):Void labelButton.x = v;
	private function changeYHandler(v:Float):Void labelButton.y = v;
	
	public function add(obj:Container):Void labelButton.add(obj);
	
}