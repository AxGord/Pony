package pony.pixi.ui;

import pony.geom.Border;

/**
 * ProgressBar
 * @author AxGord <axgord@gmail.com>
 */
class ProgressBar extends LabelBar {

	public function new(
		bg:String,
		fillBegin:String,
		fill:String,
		?animation:String,
		animationSpeed:Int = 2000,
		?border:Border<Int>,
		?style:ETextStyle,
		shadow:Bool = false,
		invert:Bool = false,
		useSpriteSheet:Bool = false,
		creep:Float = 0,
		smooth:Bool = false
	) {
		super(bg, fillBegin, fill, animation, animationSpeed, border, style, shadow, invert, useSpriteSheet, creep, smooth);
		onReady < initProgressBar; 
	}
	
	private function initProgressBar():Void {
		if (label == null) return;
		setLabel(0);
		core.changePercent << setLabel;
	}
	
	private function setLabel(v:Float):Void text = Std.int(v * 100) + '%';
	
}