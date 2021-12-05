package pony.heaps.ui.gui;

import h2d.Interactive;
import h2d.Object;
import h2d.col.Bounds;

import pony.geom.Border;
import pony.geom.Point;
import pony.ui.gui.StepSliderCore;
import pony.ui.touch.Touch;
import pony.ui.touch.Touchable;

/**
 * Step slider
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class StepSlider extends Node {

	public var button(default, null): Button;
	public var sliderCore(default, null): StepSliderCore;
	public var scaleState(default, set): Point<Float> = 1;
	public var bg(default, null): Node;
	public var valueStep(default, set): Float = 0;

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
		sliderCore = StepSliderCore.create(button.core, size.x, size.y, invert, draggable);
		sliderCore.changeX = changeXHandler;
		sliderCore.changeY = changeYHandler;
		if (sliderCore.isVertical)
			track.onDown << vertTrackClickHandler;
		else
			track.onDown << horTrackClickHandler;
	}

	private function horTrackClickHandler(t: Touch): Void {
		var b: Bounds = bg.getBounds();
		sliderCore.setStepPos(t.x - b.x + app.canvas.rect.x - button.size.x / 2 / scaleState.x);
	}

	private function vertTrackClickHandler(t: Touch): Void {
		var b: Bounds = bg.getBounds();
		sliderCore.setStepPos(t.y - b.y + app.canvas.rect.y - button.size.y / 2 / scaleState.y);
	}

	private function set_scaleState(value: Point<Float>): Point<Float> {
		scaleState = 1 / value;
		button.x = sliderX * scaleState.x;
		button.y = sliderY * scaleState.y;
		sliderCore.setSizeKeepValue(Std.int(sliderCore.isVertical ? (bg.h - button.size.y) * value.y : (bg.w - button.size.x) * value.x));
		sliderCore.valueStep = valueStep;
		return value;
	}

	private function changeXHandler(v: Float): Void {
		sliderX = v;
		button.x = v * scaleState.x;
	}

	private function changeYHandler(v: Float): Void {
		sliderY = v;
		button.y = v * scaleState.y;
	}

	public function set_valueStep(v: Float): Float {
		valueStep = v;
		sliderCore.valueStep = v;
		return v;
	}

}