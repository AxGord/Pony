package pony.heaps.ui.gui;

import h2d.Interactive;
import h2d.Object;
import h2d.col.Bounds;

import pony.geom.Border;
import pony.geom.Point;
import pony.magic.HasLink;
import pony.ui.gui.StepSliderCore;
import pony.ui.touch.Touch;
import pony.ui.touch.Touchable;

/**
 * Step slider
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class StepSlider extends Node implements HasLink {

	public var button(default, null): Button;
	public var sliderCore(default, null): StepSliderCore;
	public var bg(default, null): Node;
	public var valueStep(default, set): Float = 0;
	public var useTouchPos(link, link): Bool = sliderCore.useTouchPos;

	private var sliderX: Float = 0;
	private var sliderY: Float = 0;
	@:nullSafety(Off) private var app: HeapsApp = null;

	public function new(
		?app: HeapsApp,
		nodes: Array<Node>,
		?size: Point<Int>,
		?border: Border<Int>,
		?parent: Object,
		invert: Bool = false,
		draggable: Bool = true
	) {
		@:nullSafety(Off) var bg: Node = nodes.shift();
		if (size == null) size = bg.size.toInt();
		super(size, border, parent);
		@:nullSafety(Off) this.app = app != null ? app : HeapsApp.instance;
		this.bg = bg;
		@:nullSafety(Off) addChild(bg);
		var interactive: Interactive = new Interactive(bg.w, bg.h, bg);
		interactive.x += bg.border.left;
		interactive.y += bg.border.top;
		var track: Touchable = new Touchable(interactive);
		button = new Button(nodes, @:nullSafety(Off) this);
		sliderCore = StepSliderCore.create(button.core, size.x - button.width, size.y - button.height, invert, draggable);
		sliderCore.trackStartPoint = (sliderCore.isVertical ? button.height : button.width) / 2;
		sliderCore.convertPos = convertPos;
		sliderCore.changeX = changeXHandler;
		sliderCore.changeY = changeYHandler;
		track.onDown << trackClickHandler;
		track.onDown << sliderCore.startDrag;
		(track.onUp || track.onOutUp) << sliderCore.stopDrag;
	}

	private function convertPos(p: Point<Float>): Point<Float> return globalToLocal(p);
	private function trackClickHandler(t: Touch): Void sliderCore.stepMoveToPoint(t.point);

	private function changeXHandler(v: Float): Void {
		sliderX = v;
		button.x = v;
	}

	private function changeYHandler(v: Float): Void {
		sliderY = v;
		button.y = v;
	}

	public function set_valueStep(v: Float): Float {
		valueStep = v;
		sliderCore.valueStep = v;
		return v;
	}

}